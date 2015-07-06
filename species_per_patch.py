### Task: Use patches to get zonal statistics from bird abundance model outputs (masked by natural areas)
### and remove records that don't meet minimum number of birds criteria.
### Author: Caitlin Jensen | National Audubon Society | cjensen@audubon.org
### Revised: 06/03/2015

# Import system modules
import arcpy
from arcpy import env
from arcpy.sa import *

# Set environment settings
env.workspace = "C:/Chicago_Grasslands/Species_per_patch/Species_per_patch_20150702.gdb"
env = env.workspace
arcpy.env.overwriteOutput = True

# Check out the ArcGIS Spatial Analyst extension license
arcpy.CheckOutExtension("Spatial")

speciesList = ["boboli", "easmea", "graspa", "henspa", "sedwre"]

for species in speciesList:

    # Convert bird densities to bird counts per 30x30 m grid cell:
    inTimes = "C:/Chicago_Grasslands/Species_per_patch/" + species + "_natural_areas.tif"
    inConstant = 0.0509
    outTimes = Times(inTimes, inConstant)
    outTimes.save("C:/Chicago_Grasslands/Species_per_patch/" + species + "_natural_areas_count.tif")

    # Set local variables for Zonal Stats
    inZoneData = "patches_30acre_counties" # has unique patch_id for each patch
    zoneField = "patch_id"
    inValueRaster = "C:/Chicago_Grasslands/Species_per_patch/" + species + "_natural_areas_count.tif"
    outTable = species + "_per_patch_ZS"

    # Execute ZonalStatisticsAsTable
    outZS = ZonalStatisticsAsTable(inZoneData, zoneField, inValueRaster,
                                   outTable, "DATA", "ALL")
    
    # Join Zonal Stastitics output table to patches and export to new feature class
    arcpy.MakeFeatureLayer_management(inZoneData, "patch_layer")
    arcpy.AddJoin_management("patch_layer", zoneField, outTable, zoneField)
    arcpy.Select_analysis("patch_layer", species + "_per_patch")
    
    # Add field "bird_count"
    # arcpy.AddField_management(species + "_per_patch", "bird_count", "FLOAT")
    # For the second run, we're not adding a field anymore. Since we already converted from density to
    # counts, we can just use the "SUM" column created by the zonal statistics.
    # We rename it here:
    arcpy.AlterField_management(species + "_per_patch", species + "_per_patch_ZS_SUM", "bird_count")
    # Renaming second new_id field "patch_id" so that can be easily referenced in GIV tool script
    arcpy.AlterField_management(species + "_per_patch", species + "_per_patch_ZS_patch_id", "patch_id")
    # Not doing this step anymore in second run. Calculate number of birds in each patch
    # arcpy.CalculateField_management(species + "_per_patch", "bird_count", "!SUM! * 0.222395", "PYTHON")

    # Select only patches that meet minimum # of birds threshold.
    if species == 'boboli' or species == 'henspa':
        threshold = 11.54
    elif species == 'easmea':
        threshold = 7.77
    elif species == 'graspa':
        threshold = 7.89
    elif species == 'sedwre':
        threshold = 5.47
    whereClause = '"bird_count" >= ' + "%s" %threshold
    arcpy.Select_analysis(species + "_per_patch", species + "_per_patch_final", whereClause)

    print "done with " + species
