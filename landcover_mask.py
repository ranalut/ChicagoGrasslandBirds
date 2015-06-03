# Import system modules
import arcpy
from arcpy import env
from arcpy.sa import *

# Set environment settings
env.workspace = "C:/Chicago_Grasslands/Bird_Abundance_Model_Outputs"
arcpy.env.overwriteOutput = True

# Set local variables
inRaster = "2014_nass_reclass.tif"
inSQLClause = "VALUE = 3 OR VALUE = 6 OR VALUE = 7 OR VALUE = 11 OR VALUE = 12"

# Check out the ArcGIS Spatial Analyst extension license
arcpy.CheckOutExtension("Spatial")

# Extract natural areas from land cover raster (wheat, herbaceous wetlands, herbaceous grasslands,
# other forest and shrub, and woody wetland).
attExtract = ExtractByAttributes(inRaster, inSQLClause)

# Save the output
attExtract.save("natural_areas.tif")

# Loop through each of 5 species and extract bird model outputs by natural areas mask.

speciesList = ["boboli", "easmea", "graspa", "henspa", "sedwre"]

for species in speciesList:
    # Set local variables
    birdModel = env.workspace + "/" + species + "_nass_v36w_mean_2_cal.tif"
    mask = "natural_areas.tif"

    # Execute ExtractByMask
    outExtractByMask = ExtractByMask(birdModel, mask)

    # Save the output
    outExtractByMask.save(species + "_natural_areas.tif")