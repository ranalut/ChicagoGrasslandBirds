#-------------------------------------------------------------------------------
# Name:        grassland_bird_hotspots.py
# Purpose:
#
# Author:      cjensen
#
# Created:     17/08/2015
# Copyright:   (c) cjensen 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import arcpy
from arcpy import env

# set environmental workspace and parameters
env.workspace = r"C:\Chicago_Grasslands\Final_Outputs_20150705.gdb"

birdList = ["boboli", "easmea", "graspa", "henspa", "sedwre"]

for bird in birdList:
    input_fc = bird + "_final_v2"
    input_field = "bird_count"
    output_fc = bird + "_hotspot"
    concept = "INVERSE_DISTANCE_SQUARED"
    distance_method = "EUCLIDEAN_DISTANCE"
    standard = "NONE"

    arcpy.HotSpots_stats(input_fc, input_field, output_fc, concept, distance_method, standard)

