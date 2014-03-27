# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# raster.2.kml.py
# Created on: 2014-02-14 08:44:48.00000
#   (generated by ArcGIS/ModelBuilder)
# Description: 
# ---------------------------------------------------------------------------

# Import arcpy module
import arcpy


# Local variables:
dir = "Z" # "D"
input.tif = dir + ":\\Chicago_Grasslands\\MODELS\\boboli.landsat.v6.tif"
output.kmz = dir + ":\\Chicago_Grasslands\\MAPS\\boboli.landsat.v6-3.kmz"

# Process: Layer To KML
arcpy.LayerToKML_conversion(input.tiff, output.kmz, "1", "true", "DEFAULT", "8192", "96", "CLAMPED_TO_GROUND")

# source('C:/Python27/ArcGIS10.2/python.exe z:/github/chicagograsslandbirds/raster.2.kml.py')