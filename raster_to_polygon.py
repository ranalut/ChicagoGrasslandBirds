import arcpy
from arcpy import env
from arcpy.sa import *

env.workspace = "C:/Chicago_Grasslands"
env.overwriteOutput = True

arcpy.CheckOutExtension("Spatial")

# Determine the number of decimal places that need to be preserved. Use the Raster
# Calculator or Times tool to multiply the values in the raster by this value.
inRaster = r
inConstant = 100000
outTimes = Times(inRaster,inConstant)
outTimes.save("times_" + r)
# Use the Int tool to convert the floating point raster to an integer value.
input = "times_" + r
outInt = Int(input)
outInt.save("int_" + r)
# Convert the raster to a polygon using the Raster to Polygon Conversion tool.
input2 = "int_" + r
outPolygon = "C:/Climate_Watch/Bluebird_Change_Analysis/ClimateWatch_Pilot.gdb/" + r[:-4]
field = "Value"
arcpy.RasterToPolygon_conversion(input2,outPolygon,"NO_SIMPLIFY",field)
# Add a new field and make the type 'Double'.
fieldName = "Value2"
arcpy.AddField_management(outPolygon,fieldName,"DOUBLE")
# Calculate field with Field Calculator. Divide the GRIDCODE by the value that it
# was multiplied by before. This maintains the decimal value in the converted
# polygon feature.
expression = "[GRIDCODE] / 100000"
arcpy.CalculateField_management(outPolygon,fieldName,expression,"VB")


print "Done converting " + r