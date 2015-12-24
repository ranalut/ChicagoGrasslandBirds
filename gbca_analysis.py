#-------------------------------------------------------------------------------
# Name:        gbca_analysis.py
# Purpose:      identify tiers 1-4 GBCAs based on % grassland surrounding patch
#
# Author:      cjensen
#
# Created:     23/12/2015
# Copyright:   (c) cjensen 2015

#-------------------------------------------------------------------------------

# Import system modules
import arcpy
from arcpy import env
from arcpy.sa import *

# Set environment settings
env.workspace = "C:/Chicago_Grasslands"

# Run Zonal Statistics as Table 2 Tool from SpatialAnalystSupplementalTools
# We have to use this supplemental tool because the original doesn't calculate
# stats for overlapping polygons.
# Parameters:
# input zone feature class: C:\Chicago_Grasslands\Manuscript.gdb\unprotected_matrix
# zone field: patch_id
# input value raster: C:\Chicago_Grasslands\natural_areas.tif
# output table: C:\Chicago_Grasslands\Manuscript.gdb\natural_areas_matrix_zs


# Set the local parameters for Join Field
inFeatures = "C:/Chicago_Grasslands/Manuscript.gdb/unprotected_matrix"
joinField = "patch_id"
joinTable = "C:/Chicago_Grasslands/Manuscript.gdb/natural_areas_matrix_zs"
fieldList = ["COUNT"]

### Join two feature classes by the zonecode field and only carry
### over the COUNT field
##arcpy.JoinField_management (inFeatures, joinField, joinTable, joinField, fieldList)

### Add "grass_ha" field representing the amount of grassland area (hectares)
### in each buffered patch ("blob")
##fieldName = "grass_ha"
##arcpy.AddField_management(inFeatures, fieldName, "DOUBLE")

### Calculate "grass_ha" field by multiplying the number of pixels within each
### blob by the cell size
##expression = "[COUNT_1] * 0.09"
##arcpy.CalculateField_management(inFeatures, fieldName, expression)

### Add "total_ha" field representing the total area of each blob (hectares)
##fieldName2 = "total_ha"
##arcpy.AddField_management(inFeatures, fieldName2, "DOUBLE")
##
### Calculate "total_ha"
##expression2 = "!shape.area@hectares!"
##arcpy.CalculateField_management(inFeatures, fieldName2, expression2, "PYTHON")

### Add "percent_grass" field representing the proportion of grassland in each blob
##fieldName3 = "percent_grass"
##arcpy.AddField_management(inFeatures, fieldName3, "DOUBLE")
##
### Calculate "percent_grass" by dividing "grass_ha" by "total_ha" and multiplying
### by 100
##expression3 = "([grass_ha]/[total_ha]) * 100"
##arcpy.CalculateField_management(inFeatures, fieldName3, expression3)

# Add "gbca_type" field representing the GBCA type attributed to the core
fieldName4 = "gbca_type"
arcpy.AddField_management(inFeatures, fieldName4, "SHORT")

# In Arc desktop, define "gbca_type" based on the following criteria:

# if core_type = 1 AND percent_grass >= 40, then gbca_type = 1
# if core_type = 1 AND percent_grass < 40 AND percent_grass >= 30, then gbca_type = 2
# if core_type = 1 AND percent_grass < 30 AND percent_grass >= 20,then gbca_type = 3
# if core_type = 1 AND percent_grass < 20 AND percent_grass >= 10,then gbca_type = 4
# if core_type = 1 AND percent_grass < 10,then gbca_type = 0

# if core_type = 2 AND percent_grass >= 30, then gbca_type = 2
# if core_type = 2 AND percent_grass < 30 AND percent_grass >= 20, then gbca_type = 3
# if core_type = 2 AND percent_grass < 20 AND percent_grass >= 10, then gbca_type = 4
# if core_type = 2 AND percent_grass < 10,then gbca_type = 0

# if core_type = 3 AND percent_grass >= 20,then gbca_type = 3
# if core_type = 3 AND percent_grass < 20 AND percent_grass >= 10, then gbca_type = 4
# if core_type = 3 AND percent_grass < 10,then gbca_type = 0

# if core_type = 4 AND percent_grass >= 10,then gbca_type = 4
# if core_type = 4 AND percent_grass < 10,then gbca_type = 0

# Join "gbca_type" field to patches feature class
# Set the local parameters for Join Field
inFeatures2 = "C:/Chicago_Grasslands/Grassland_Patches_CMAP.gdb/unprotected_patches_across_species"
joinField2 = "patch_id"
joinTable2 = "C:/Chicago_Grasslands/Manuscript.gdb/unprotected_matrix"
fieldList2 = ["gbca_type"]

# Join two feature classes by the patch_id field and only carry
# over the gbca_type field
arcpy.JoinField_management (inFeatures2, joinField2, joinTable2, joinField2, fieldList2)