import arcpy
from arcpy import env
from arcpy.sa import *

env.workspace = "C:/Chicago_Grasslands/"
env.overwriteOutput = True

arcpy.CheckOutExtension("Spatial")


# Determine the number of decimal places that need to be preserved. Use the Raster
# Calculator or Times tool to multiply the values in the raster by this value. 
inRaster = "patches_protected_focalStats.tif"
inConstant = 1000
outTimes = Times(inRaster,inConstant)
outTimes.save("patches_protected_focalStats_times.tif")
# Use the Int tool to convert the floating point raster to an integer value. 
input = "patches_protected_focalStats_times.tif"
outInt = Int(input)
outInt.save("patches_protected_focalStats_int.tif")
# Convert the raster to a polygon using the Raster to Polygon Conversion tool. 
input2 = "patches_protected_focalStats_int.tif"
outPolygon = "C:/Chicago_Grasslands/ChicagoGrasslands.gdb/patches_protected_focalStats"
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

print "finished"
    
