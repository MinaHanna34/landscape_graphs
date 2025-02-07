library(xml2)
library(dplyr)
library(stringr)
library(terra)   
library(timeseriesTrajectories)
library(tidyr)   

# Folder path
xml_folder <- "C:/Users/minat/Downloads/Graphs/area_of_interest/"
xml_files <- list.files(xml_folder, pattern = "Annual_NLCD_LndCov_.*\\.xml$", full.names = TRUE)

# Initialize empty data frame to store results
landcover_data <- data.frame(year = integer(), spectral_change_day = numeric())

# Loop through XML files and extract relevant data
for (file in xml_files) {
  
  xml_data <- read_xml(file)
  
  # Extract Year from filename
  year <- as.numeric(stringr::str_extract(basename(file), "\\d{4}"))

      change_days <- as.numeric(xml_text(xml_find_all(xml_data, "//PAMRasterBand/Metadata/MDI[@key='STATISTICS_MEAN']")))

  # Ensure valid numeric values
  change_days <- change_days[!is.na(change_days) & change_days > 0]

  # Skip files with no valid change day values
  if (length(change_days) == 0) next

  # Store the mean change day for the given year
  mean_change_day <- mean(change_days, na.rm = TRUE)
  
  # Append results
  landcover_data <- bind_rows(landcover_data, data.frame(year = year, spectral_change_day = mean_change_day))
}

# Remove NA values
landcover_data <- na.omit(landcover_data)

 

# Ensure dfstackData() receives a correctly formatted dataset
if (nrow(landcover_data) == 0) {
  print(" No valid data extracted from XML files.")
} else {
  
  # Convert data into wide format
  formatted_data <- landcover_data %>%
    pivot_wider(names_from = year, values_from = spectral_change_day) %>%
    as.data.frame()  

  # Ensure all columns are numeric

  formatted_data[] <- lapply(formatted_data, function(x) as.numeric(as.character(x)))
  #Process data using dfstackData()
  stackbar_data <- dfstackData(formatted_data,
                               timePoints = as.numeric(colnames(formatted_data)), 
                               spatialextent = 'unified',
                               zeroabsence = 'yes',
                               annualchange = 'yes',
                               categoryName = 'Spectral Change',
                               regionName = 'region',
                               varUnits = "Spectral Change Day")

  #Validate that stackbar_data[[1]] exists and is not NULL before plotting
  if (!is.null(stackbar_data[[1]]) && is.data.frame(stackbar_data[[1]])) {

    #Create the stacked bar plot
    stackbarPlot(stackbar_data,
                 axisSize = 10,
                 lbAxSize = 10,
                 lgSize = 7.5,
                 titleSize = 12,
                 datbreaks = "no",
                 upperlym = 35,
                 lowerlym = -50,
                 lymby = 2,  
                 upperlym2 = 0.5,
                 lymby2 = 0.1,
                 xAngle = 0)

  }  
}
