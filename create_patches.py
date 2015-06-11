# Task: Create a feature class containing only patches of natural areas larger than 30 acres
# Author: Caitlin Jensen | National Audubon Society | cjensen@audubon.org
# Revised: 06/03/2015

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

# Assign each patch with a county name. If a patch spans more than one
# county, then base the assignment on where the majority of the area
# of the patch is.
inFeatures = ["patches_30acre_counties", "cmap_counties"]
intersectOutput = "patches_counties_intersect_TEST"
statsTable = intersectOutput + "_SS"
statsFields = [["Shape_Area", "MAX"]]
caseField = "FID_patches_30acre_counties"
in_field = "Shape_Area"
join_field = "MAX_Shape_Area"
where_clause = '"MAX_Shape_Area" > 0'

#arcpy.Intersect_analysis(inFeatures, intersectOutput)
#arcpy.Statistics_analysis(intersectOutput, statsTable, statsFields, caseField)
#arcpy.JoinField_management(intersectOutput, in_field, statsTable, join_field)
#arcpy.Select_analysis(intersectOutput, "intersect_max_area", where_clause)
#arcpy.JoinField_management(inFeatures[0], "OBJECTID", "intersect_max_area", caseField)
#arcpy.AddField_management(inFeatures[0], "county_name", "TEXT")
arcpy.CalculateField_management(inFeatures[0], "county_name", "!NAME!", "PYTHON")

### Use Identity to tag each patch with its county name. We ended up not using Identity because it fragments the
### patches that span multiple counties.
##inFeatures = "patches_30acre_counties"
##idFeatures = "cmap_counties"
##outFeatures = "patches_30acre_cmap"
##arcpy.Identity_analysis(inFeatures, idFeatures, outFeatures)


### Add and calculate "acreage2" field - this is the acreage for the polygons after Identity was run, which created
### additional polygons when a patch covered more than one county.
##arcpy.AddField_management("patches_30acre_cmap", "acreage2", "FLOAT")
##arcpy.CalculateField_management("patches_30acre_cmap", "acreage2", "!shape.area@acres!", "PYTHON")

# last step is to add a new integer field called "new_id" that serves as the unique id for each patch (including
# new, smaller patches resulting from fragmentation caused by Identity) using
# the python code below in field calculator
arcpy.AddField_management(inFeatures[0], "patch_id", "SHORT")

codeblock = """
counter = 0
def uniqueID():
    global counter
    counter += 1
    return counter"""
arcpy.CalculateField_management(inFeatures[0], "patch_id", "uniqueID()", "PYTHON", codeblock)



