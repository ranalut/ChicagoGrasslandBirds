# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# kernel.density.py
# Created on: 2014-02-12 16:19:59.00000
#   (generated by ArcGIS/ModelBuilder)
# Description: 
# ---------------------------------------------------------------------------

# Import arcpy module
import arcpy

# Check out any necessary licenses
arcpy.CheckOutExtension("spatial")


# Local variables:
all_records_full_counts_albers = "all_records_full_counts_albers"
Extent = "593000 2043000 707000 2199000"
all_records_full_counts_albers__2_ = "all_records_full_counts_albers"
sedwre_2km = "D:\\Chicago_Grasslands\\BIRD_DATA\\BCN\\sedwre_2km"

# Process: Select Layer By Attribute
arcpy.SelectLayerByAttribute_management(all_records_full_counts_albers, "NEW_SELECTION", "\"SPECIES_CO\" = 'sedwre' AND( \"YEAR\" = 2007 OR \"YEAR\" = 2008 OR \"YEAR\" = 2009 OR \"YEAR\" = 2010 OR \"YEAR\" = 2011 )")

# Process: Kernel Density
tempEnvironment0 = arcpy.env.extent
arcpy.env.extent = "593000 2043000 707000 2199000"
arcpy.gp.KernelDensity_sa(all_records_full_counts_albers__2_, "HOW_MANY_A", sedwre_2km, "100", "2000", "HECTARES")
arcpy.env.extent = tempEnvironment0

