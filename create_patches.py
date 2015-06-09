### Task: Create a feature class containing only patches of natural areas larger than 30 acres
### Author: Caitlin Jensen | National Audubon Society | cjensen@audubon.org
### Revised: 06/03/2015

# Before running this script, run clump_patches.r on natural_areas.tif to get natural_areas_clump.tif

# Import system modules
import arcpy
from arcpy import env

# Set environment settings
env.workspace = "C:/Chicago_Grasslands/Species_per_patch/Species_per_patch.gdb"
env.overwriteOutput = True

### Set local variables
raster = "C:/Chicago_Grasslands/Bird_Abundance_Model_Outputs/natural_areas_clump.tif"
polygon = "natural_areas_clump"
field = "VALUE"

# Execute RasterToPolygon - converts clumped raster into feature class.
arcpy.RasterToPolygon_conversion(raster, polygon, "NO_SIMPLIFY", field)

# Remove gravel pits + 10 m buffer
eraseOutput = polygon + "_no_pits"
arcpy.Erase_analysis(polygon, "gravel_pits_10mbuff", eraseOutput)

# Repair Geometry just in case...
arcpy.RepairGeometry_management(eraseOutput)

# Execute MultipartToSinglepart - convert multipart into singleparts.
arcpy.MultipartToSinglepart_management(eraseOutput, "patches")

# Add and calculate "acreage" field
arcpy.AddField_management("patches", "acreage", "FLOAT")
arcpy.CalculateField_management("patches", "acreage", "!shape.area@acres!", "PYTHON")

# Select only records having an acreage >= 30
arcpy.Select_analysis("patches", "patches_30acre", '"acreage" >= 30')

# Select only records intersecting with CMAP counties and export to new feature class "patches_30acre_cmap"
arcpy.MakeFeatureLayer_management("patches_30acre", "patches_layer")
arcpy.SelectLayerByLocation_management("patches_layer", "INTERSECT", "cmap_counties")
arcpy.CopyFeatures_management("patches_layer", "patches_30acre_counties")

# Use Identity to tag each patch with its county name
inFeatures = "patches_30acre_counties"
idFeatures = "cmap_counties"
outFeatures = "patches_30acre_cmap"
arcpy.Identity_analysis(inFeatures, idFeatures, outFeatures)

# Delete unnecessary fields
dropFields = ["STATE_NAME", "STATE_FIPS", "CNTY_FIPS",
              "FIPS", "POP2000", "POP00_SQMI", "POP2010", "POP10_SQMI", "WHITE", "BLACK", "AMERI_ES",
              "ASIAN", "HAWN_PI", "OTHER", "MULT_RACE", "HISPANIC", "MALES", "FEMALES", "AGE_UNDER5",
              "AGE_5_17", "AGE_18_21", "AGE_22_29", "AGE_30_39", "AGE_40_49", "AGE_50_64", "AGE_65_UP",
              "MED_AGE", "MED_AGE_M", "MED_AGE_F", "HOUSEHOLDS", "AVE_HH_SZ", "HSEHLD_1_M", "HSEHLD_1_F",
              "MARHH_CHD", "MARHH_NO_C", "MHH_CHILD", "FHH_CHILD", "FAMILIES", "AVE_FAM_SZ", "HSE_UNITS",
              "VACANT", "OWNER_OCC", "RENTER_OCC", "NO_FARMS07", "AVG_SIZE07", "CROP_ACR07", "AVG_SALE07",
              "SQMI", "acres"]
arcpy.DeleteField_management("patches_30acre_cmap", dropFields)

# Add and calculate "acreage2" field - this is the acreage for the polygons after Identity was run, which created
# additional polygons when a patch covered more than one county.
arcpy.AddField_management("patches_30acre_cmap", "acreage2", "FLOAT")
arcpy.CalculateField_management("patches_30acre_cmap", "acreage2", "!shape.area@acres!", "PYTHON")

# last step is to add a new integer field called "new_id" that serves as the unique id for each patch (including
# new, smaller patches resulting from fragmentation caused by Identity) using
# the python code below in field calculator
arcpy.AddField_management("patches_30acre_cmap", "new_id", "SHORT")

codeblock = """
counter = 0
def uniqueID():
    global counter
    counter += 1
    return counter"""
arcpy.CalculateField_management("patches_30acre_cmap", "new_id", "uniqueID()", "PYTHON", codeblock)



