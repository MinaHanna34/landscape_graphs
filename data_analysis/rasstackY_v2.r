# Load required libraries
library(terra)
library(devtools)
library(timeseriesTrajectories)

# Define file paths for the 5-year data
file_paths <- c(
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_1985_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff",
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_2000_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff",
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_2010_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff",
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_2015_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff",
  "C:/Users/minat/Downloads/Graphs/area_of_interest/Annual_NLCD_LndCov_2023_CU_C1V0_8XkLUMJmy16Ri8RUrAqH.tiff"
)

# Define the correct years
years <- c(1985, 2000, 2010, 2015, 2023)

# Read the raster files as a SpatRaster stack
rasstackY <- rast(file_paths)

# Define NLCD classification values and corresponding colors (from the official NLCD scheme)
nlcd_values <- c(11, 12, 21, 22, 23, 24, 31, 41, 42, 43, 52, 71, 72, 73, 74, 81, 82, 90, 95)
nlcd_classes <- c("Open Water (11)", "Perennial Ice/Snow (12)", "Developed, Open Space (21)", 
                  "Developed, Low Intensity (22)", "Developed, Medium Intensity (23)", 
                  "Developed, High Intensity (24)", "Barren Land (31)", "Deciduous Forest (41)", 
                  "Evergreen Forest (42)", "Mixed Forest (43)", "Shrub/Scrub (52)", 
                  "Grasslands/Herbaceous (71)", "Sedge/Herbaceous (72)", "Lichens (73)", 
                  "Moss (74)", "Pasture/Hay (81)", "Cultivated Crops (82)", "Woody Wetlands (90)", 
                  "Emergent Herbaceous Wetlands (95)")

nlcd_colors <- c("#466B9F", "#D1DEF8", "#DEC4C4", "#D89382", "#ED0000", "#AA0000", 
                 "#B2ADA3", "#68AA63", "#1C6330", "#B5C98E", "#CCBA7C", "#E3E3C2",
                 "#DBD83E", "#C2C1C0", "#DCD939", "#A58C30", "#FFCC99", "#C8E6F8", "#64B3E8")

# Ensure correct color assignment by mapping values
color_map <- setNames(nlcd_colors, as.character(nlcd_values))

# Adjust figure layout to fit 6 slots (5 maps + 1 empty for legend)
par(mfrow = c(2, 3), mar = c(4, 4, 2, 4))  # Adjust right margin

# Plot each raster in its correct year position
for (i in 1:nlyr(rasstackY)) {
  plot(rasstackY[[i]], main = paste("Year", years[i]), 
       col = color_map[as.character(unique(values(rasstackY[[i]])))])
}

# Add an **empty plot** in the 6th position for the legend
plot.new()

# Move the legend inside the empty plot
par(xpd = TRUE)
legend("center", legend = nlcd_classes, fill = nlcd_colors, 
       title = "NLCD Land Cover", cex = 0.9, bty = "n")

# Reset plotting layout
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

# Print summary of raster values
print(summary(rasstackY))
