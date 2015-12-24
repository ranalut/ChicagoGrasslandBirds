#-------------------------------------------------------------------------------
# Name:        raster_to_polygon_climatewatch.py
# Purpose:      convert grids to polygons and create unique id field for grid cells
#
# Author:      cjensen
#
# Created:     24/10/2015
# Copyright:   (c) cjensen 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import arcpy
from arcpy import env
from arcpy.sa import *

env.workspace = "C:/Climate_Watch/Bluebird_Change_Analysis/ClimateWatch_Pilot.gdb"
env.overwriteOutput = True

arcpy.CheckOutExtension("Spatial")

##rasters = ["EABL_gain_absence_CBC.img",
##            "EABL_loss_presence_CBC.img",
##            "EABL_stasis_presence_CBC.img",
##            "MOBL_gain_absence_CBC.img",
##            "MOBL_loss_presence_CBC.img",
##            "MOBL_stasis_presence_CBC.img",
##            "WEBL_gain_absence_CBC.img",
##            "WEBL_loss_presence_CBC.img",
##            "WEBL_stasis_presence_CBC.img"]
##
##for r in rasters:
##    # Determine the number of decimal places that need to be preserved. Use the Raster
##    # Calculator or Times tool to multiply the values in the raster by this value.
##    inRaster = r
##    inConstant = 100000
##    outTimes = Times(inRaster,inConstant)
##    outTimes.save("times_" + r)
##    # Use the Int tool to convert the floating point raster to an integer value.
##    input = "times_" + r
##    outInt = Int(input)
##    outInt.save("int_" + r)
##    # Convert the raster to a polygon using the Raster to Polygon Conversion tool.
##    input2 = "int_" + r
##    outPolygon = "C:/Climate_Watch/Bluebird_Change_Analysis/ClimateWatch_Pilot.gdb/" + r[:-4]
##    field = "Value"
##    arcpy.RasterToPolygon_conversion(input2,outPolygon,"NO_SIMPLIFY",field)
##    # Add a new field and make the type 'Double'.
##    fieldName = "Value2"
##    arcpy.AddField_management(outPolygon,fieldName,"DOUBLE")
##    # Calculate field with Field Calculator. Divide the GRIDCODE by the value that it
##    # was multiplied by before. This maintains the decimal value in the converted
##    # polygon feature.
##    expression = "[GRIDCODE] / 100000"
##    arcpy.CalculateField_management(outPolygon,fieldName,expression,"VB")
##
##
##    print "Done converting " + r

##fcs = ["EABL_gain_absence_CBC",
##            "EABL_loss_presence_CBC",
##            "EABL_stasis_presence_CBC",
##            "MOBL_gain_absence_CBC",
##            "MOBL_loss_presence_CBC",
##            "MOBL_stasis_presence_CBC",
##            "WEBL_gain_absence_CBC",
##            "WEBL_loss_presence_CBC",
##            "WEBL_stasis_presence_CBC"]
##
##for fc in fcs:
##    # Add new "surveyed" field for Climate Watch pilot
##    fieldName = "Surveyed"
##    arcpy.AddField_management(fc,fieldName,"TEXT")

# Add new fields to be concatenated to form unique grid cell ids for labeling
gain_list = ["MOBL_gain_absence_CBC","WEBL_gain_absence_CBC"]

loss_list = ["EABL_loss_presence_CBC","MOBL_loss_presence_CBC","WEBL_loss_presence_CBC"]

stasis_list = ["EABL_stasis_presence_CBC","MOBL_stasis_presence_CBC","WEBL_stasis_presence_CBC"]

codeblock = """
counter = 0
def uniqueID():
    global counter
    counter += 1
    return counter"""

##for g in gain_list:
##    expression = "!Category! + str(!Number!)"
##
##    arcpy.AddField_management(g, "Category", "TEXT")
##    arcpy.AddField_management(g, "Number", "SHORT")
##    arcpy.AddField_management(g, "Unique_ID", "TEXT")
##
##    arcpy.CalculateField_management(g, "Category", '"G"', "VB")
##    print "Calculated category"
##    arcpy.CalculateField_management(g, "Number", "uniqueID()", "PYTHON", codeblock)
##    print "Calculated number"
##    arcpy.CalculateField_management(g, "Unique_ID", expression, "PYTHON")
##    print "Calculated unique id"

for l in loss_list:
    expression = "!Category! + str(!Number!)"

    arcpy.AddField_management(l, "Category", "TEXT")
    arcpy.AddField_management(l, "Number", "SHORT")
    arcpy.AddField_management(l, "Unique_ID", "TEXT")

    arcpy.CalculateField_management(l, "Category", '"L"', "VB")
    print "Calculated category"
    arcpy.CalculateField_management(l, "Number", "uniqueID()", "PYTHON", codeblock)
    print "Calculated number"
    arcpy.CalculateField_management(l, "Unique_ID", expression, "PYTHON")
    print "Calculated unique id"

for s in stasis_list:
    expression = "!Category! + str(!Number!)"

    arcpy.AddField_management(s, "Category", "TEXT")
    arcpy.AddField_management(s, "Number", "SHORT")
    arcpy.AddField_management(s, "Unique_ID", "TEXT")

    arcpy.CalculateField_management(s, "Category", '"S"', "VB")
    print "Calculated category"
    arcpy.CalculateField_management(s, "Number", "uniqueID()", "PYTHON", codeblock)
    print "Calculated number"
    arcpy.CalculateField_management(s, "Unique_ID", expression, "PYTHON")
    print "Calculated unique id"