### Task: 
### Author: Caitlin Jensen | National Audubon Society | cjensen@audubon.org
### Revised: 06/08/2015

# Import system modules
import arcpy
from arcpy import env
from arcpy.sa import *

# Set environment settings
env.workspace = "C:/Chicago_Grasslands/Species_per_patch/Species_per_patch_final.gdb"
arcpy.env.overwriteOutput = True

speciesList = ['boboli', 'easmea', 'graspa', 'henspa', 'sedwre']

for species in speciesList:
    inFeatures = species + "_per_patch_final"
    layerName = species + "_layer"
    joinField = "patch_id"
    joinTable = "compiled_" + species
    outFeature = inFeatures + "_ES"
    zoneFC = "C:/Chicago_Grasslands/ChicagoGrasslands.gdb/Protected_Land_albers_dissolve"
    zoneFld = "OBJECTID"
    outTab = species + "_protected_TI"
    
    # Join compiled table of GIV tool outputs to bird output and export to new feature class
    arcpy.MakeFeatureLayer_management(inFeatures, layerName)
    arcpy.AddJoin_management(layerName, joinField, joinTable, joinField)
    arcpy.CopyFeatures_management(layerName, outFeature)

    # Run Tabulate Intersection to find area that is protected within each patch
    arcpy.TabulateIntersection_analysis(zoneFC, zoneFld, outFeature, outTab, joinField