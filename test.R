# Load required packages
library(timeseriesTrajectories)
library(terra)  # Required for raster operations
 

# Start interactive graphics device

rasstackY <- terra::rast(system.file("external/binary_raster_stack.tif",package="timeseriesTrajectories"))
rasstackY
# create a data frame for your range of values
reclass_df <- cbind(from = c(1), 
                    to = c(2), 
                    becomes = c(2))

#Use terra's **classify** function to reclassify the raster stacked based on your reclassification data frame.
# Setting "include.lowest = TRUE" ensures that the lower limit of the range is included in the values to be reclassified.
#  see terra's **classify** function for more information.
rasstackY_v2 <- classify(rasstackY,reclass_df,include.lowest = TRUE)

# Visualize the reclassified raster data
plot(rasstackY_v2)



#Graph 2
# Create a vector for the time points.
tps = c(2000,2001,2002,2003,2005)

# I know the units of my varibel is number of pixels, thus I will create a sting for the vertical units.
vert_units <- "number of pixels"

# Next, pass the variables to the dataPreview function.
# NB: xAngle sets the orientation of the horizontal axis labels. See help file for more details.
dataPreview(rasstackY,
            timepoints = tps,
            vertunits = vert_units,
            xAngle = 0)
#for VS code
png("Graph1.png")
plot(rasstackY_v2)
dev.off()