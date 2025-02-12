# Load required libraries
library(terra)
library(devtools)
library(timeseriesTrajectories)

# Define file paths for the 5-year data
file_paths <- c(
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_1990_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff",
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_1996_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff",
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_2004_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff",
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_2010_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff",
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_2023_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff"
)

# Initialize lists to store min and max values
years <- c(1990, 1996, 2004, 2010, 2023)
min_values <- numeric(length(file_paths))
max_values <- numeric(length(file_paths))

# Read and process each raster file
for (i in seq_along(file_paths)) {
  ras <- rast(file_paths[i])  # Load raster file
  min_values[i] <- min(values(ras), na.rm = TRUE)  # Get min value
  max_values[i] <- max(values(ras), na.rm = TRUE)  # Get max value
}

# Print extracted min and max values
min_max_data <- data.frame(Year = years, Min = min_values, Max = max_values)
print(min_max_data)

# Plot min and max values over time
plot(years, min_values, type = "o", col = "blue", ylim = range(c(min_values, max_values)),
     xlab = "Year", ylab = "Value", main = "Minimum and Maximum Values Over Time",
     pch = 16, lwd = 2)
lines(years, max_values, type = "o", col = "red", pch = 16, lwd = 2)
legend("topright", legend = c("Min Values", "Max Values"), col = c("blue", "red"), lwd = 2, pch = 16)

# Read the raster files as a SpatRaster stack
rasstackY <- rast(file_paths)

# Print raster stack details
print(rasstackY)

# Visualize the original raster stack
plot(rasstackY, main = "Original Raster Data (5-Year Time Series)")

# Create a data frame for reclassification 
reclass_df <- data.frame(from = c(1))

# Apply classification to the raster stack
rasstackY_v2 <- classify(rasstackY, reclass_df, include.lowest = TRUE)

# Visualize the reclassified raster data for each time step
par(mfrow = c(2, 3))  # Set up a 2-row, 3-column layout for multiple plots
for (i in 1:nlyr(rasstackY_v2)) {
  plot(rasstackY_v2[[i]], main = paste("Year", years[i]))
}

# Reset the plotting layout
par(mfrow = c(1, 1))

# Alternative: Summary of raster values instead of trajSummary()
print(summary(rasstackY_v2))
