
# Import arcpy module
import arcpy
from arcpy.sa import *

# Check out any necessary licenses
arcpy.CheckOutExtension("spatial")

# Local variables:
input = "D:\\Chicago_Grasslands\\Temp\\temp_dist.tif"
# Extent = "552735 1992075 847725 2280285"
output = "D:\\Chicago_Grasslands\\Temp\\temp_dist_2.tif"
Output_direction_raster = ""

# Process: Euclidean Distance
tempEnvironment0 = arcpy.env.snapRaster
arcpy.env.snapRaster = "D:\\Chicago_Grasslands\\NASS2\\updated_cdl_2014\\2007_corn_nass_30m_r1000.tif"
tempEnvironment1 = arcpy.env.extent
arcpy.env.extent = "552758 1992114 847766 2280290"

arcpy.gp.EucDistance_sa(input, output, "", "30", Output_direction_raster)

# Execute ExtractByMask
outExtractByMask = ExtractByMask(output, "D:\\Chicago_Grasslands\\NASS2\\updated_cdl_2014\\CDL_2007_clip_20150129145939_195531972.tif")

# Save the output 
outExtractByMask.save("D:\\Chicago_Grasslands\\Temp\\temp_dist_3.tif")

# Execute RoundDown
outRoundDRaster = RoundDown("D:\\Chicago_Grasslands\\Temp\\temp_dist_3.tif")

# Save the output 
outRoundDRaster.save("D:\\Chicago_Grasslands\\Temp\\temp_dist_4.tif")

# In order to return to baseline
arcpy.env.snapRaster = tempEnvironment0
arcpy.env.extent = tempEnvironment1
