import arcpy
from arcpy import env
from arcpy.sa import *

env.workspace = "C:/Chicago_Grasslands/Calibrated Abundance Outputs - natural areas/"

arcpy.CheckOutExtension("Spatial")

speciesList = ["boboli","easmea","graspa","henspa","sedwre"]

for species in speciesList:
    # Determine the number of decimal places that need to be preserved. Use the Raster
    # Calculator or Times tool to multiply the values in the raster by this value. 
    inRaster = species + "_natural_areas.tif"
    inConstant = 1000
    outTimes = Times(inRaster,inConstant)
    outTimes.save(species + "_natural_areas_times.tif")
    # Use the Int tool to convert the floating point raster to an integer value. 
    input = species + "_natural_areas_times.tif"
    outInt = Int(input)
    outInt.save(species + "_natural_areas_int.tif")
    # Convert the raster to a polygon using the Raster to Polygon Conversion tool. 
    input2 = species + "_natural_areas_int.tif"
    outPolygon = "C:/Chicago_Grasslands/ChicagoGrasslands.gdb/" + species + "_natural_areas_polygon"
    field = "Value"
    arcpy.RasterToPolygon_conversion(input2,outPolygon,"NO_SIMPLIFY",field)
    # Add a new field and make the type 'Double'.
    fieldName = "Value2"
    arcpy.AddField_management(outPolygon,fieldName,"DOUBLE")
    # Calculate field with Field Calculator. Divide the GRIDCODE by the value that it
    # was multiplied by before. This maintains the decimal value in the converted
    # polygon feature.
    expression = "[GRIDCODE] / 1000"
    arcpy.CalculateField_management(outPolygon,fieldName,expression,"VB")


# Convert feature classes to shapefiles.
inFeatures = ["C:/Chicago_Grasslands/ChicagoGrasslands.gdb/boboli_natural_areas_polygon",
              "C:/Chicago_Grasslands/ChicagoGrasslands.gdb/easmea_natural_areas_polygon",
              "C:/Chicago_Grasslands/ChicagoGrasslands.gdb/graspa_natural_areas_polygon",
              "C:/Chicago_Grasslands/ChicagoGrasslands.gdb/henspa_natural_areas_polygon",
              "C:/Chicago_Grasslands/ChicagoGrasslands.gdb/sedwre_natural_areas_polygon"]
arcpy.FeatureClassToShapefile_conversion(inFeatures,env.workspace)
    