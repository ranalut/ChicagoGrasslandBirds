import arcpy
from arcpy import env
from arcpy.sa import *

arcpy.CheckOutExtension("Spatial")

env.workspace = "C:/Chicago_Grasslands/Combined_Index"

arcpy.env.overwriteOutput = True

##speciesList = ["boboli","easmea","graspa","henspa","sedwre"]
##
### For each species, rescale by dividing raster by its maximum value.
##for species in speciesList:
##    # Maximum value for each calibrated abundance raster
##    if species == 'boboli':
##        constant = 4.40566
##    elif species == 'easmea':
##        constant = 2.71828
##    elif species == 'graspa':
##        constant = 8.87048
##    elif species == 'henspa':
##        constant = 23.7755
##    elif species == 'sedwre':
##        constant = 7.49736
##
##    inRaster = "C:/Chicago_Grasslands/Bird_Abundance_Model_Outputs/" + species + "_natural_areas.tif"
##    outDivide = Divide(inRaster, constant)
##    outDivide.save(species + "_index.tif")
##
### Create new, individual rasters for each ecosystem service valuation dataset.
##esList = ["flood_i","groundw_i","waterpur_i","carbon_i"]
##
##for es in esList:
##    inRas = "C:/Chicago_Grasslands/GIV2_3_EcosystemServiceValues1_COPY_albers.tif"
##    outRas = Lookup(inRas, es)
##    outRas.save(es + ".tif")
##
# Average across ecosystem service indices
raster1 = "flood_i.tif"
raster2 = "groundw_i.tif"
raster3 = "waterpur_i.tif"
raster4 = "carbon_i.tif"
average = CellStatistics([raster1,raster2,raster3,raster4], "MEAN", "DATA")
average.save("ecosystem_services_index_avg.tif")


##ES_index_sum = Plus("flood_i.tif" + "groundw_i.tif" + "waterpur_i.tif" + "carbon_i.tif")
##ES_index_sum.save("ecosystem_services_index_sum.tif")
##ES_index_avg = Divide("ecosystem_services_index_sum.tif", 4)
##ES_index_avg.save("ecosystem_services_index_avg.tif")

# Create combined indices:
# Average ES and boboli
output1 = Plus("ecosystem_services_index_avg.tif","boboli_index.tif")
output1.save("avg_ES_boboli_combined.tif")
# Average ES and easmea
output2 = Plus("ecosystem_services_index_avg.tif","easmea_index.tif")
output2.save("avg_ES_easmea_combined.tif")
# Average ES and graspa
output3 = Plus("ecosystem_services_index_avg.tif","graspa_index.tif")
output3.save("avg_ES_graspa_combined.tif")
# Average ES and henspa
output4 = Plus("ecosystem_services_index_avg.tif","henspa_index.tif")
output4.save("avg_ES_henspa_combined.tif")
# Average ES and sedwre
output5 = Plus("ecosystem_services_index_avg.tif","sedwre_index.tif")
output5.save("avg_ES_sedwre_combined.tif")

### Flood Control and boboli
##outPlus1 = Plus("flood_i.tif","boboli_index.tif")
##outPlus1.save("FloodContr_boboli_combined_index.tif")
##
### Flood Control and easmea
##outPlus2 = Plus("flood_i.tif","easmea_index.tif")
##outPlus2.save("FloodContr_easmea_combined_index.tif")
##
### Flood Control and graspa
##outPlus3 = Plus("flood_i.tif","graspa_index.tif")
##outPlus3.save("FloodContr_graspa_combined_index.tif")
##
### Flood Control and henspa
##outPlus4 = Plus("flood_i.tif","henspa_index.tif")
##outPlus4.save("FloodContr_henspa_combined_index.tif")
##
### Flood Control and sedwre
##outPlus5 = Plus("flood_i.tif","sedwre_index.tif")
##outPlus5.save("FloodContr_sedwre_combined_index.tif")
##
### Groundwater Recharge and boboli
##outPlus6 = Plus("groundw_i.tif","boboli_index.tif")
##outPlus6.save("Groundwate_boboli_combined_index.tif")
##
### Groundwater Recharge and easmea
##outPlus7 = Plus("groundw_i.tif","easmea_index.tif")
##outPlus7.save("Groundwate_easmea_combined_index.tif")
##
### Groundwater Recharge and graspa
##outPlus8 = Plus("groundw_i.tif","graspa_index.tif")
##outPlus8.save("Groundwate_graspa_combined_index.tif")
##
### Groundwater Recharge and henspa
##outPlus9 = Plus("groundw_i.tif","henspa_index.tif")
##outPlus9.save("Groundwate_henspa_combined_index.tif")
##
### Groundwater Recharge and sedwre
##outPlus10 = Plus("groundw_i.tif","sedwre_index.tif")
##outPlus10.save("Groundwate_sedwre_combined_index.tif")
##
### Water Purification and boboli
##outPlus11 = Plus("waterpur_i.tif","boboli_index.tif")
##outPlus11.save("WaterPurif_boboli_combined_index.tif")
##
### Water Purification and easmea
##outPlus12 = Plus("waterpur_i.tif","easmea_index.tif")
##outPlus12.save("WaterPurif_easmea_combined_index.tif")
##
### Water Purification and graspa
##outPlus13 = Plus("waterpur_i.tif","graspa_index.tif")
##outPlus13.save("WaterPurif_graspa_combined_index.tif")
##
### Water Purification and henspa
##outPlus14 = Plus("waterpur_i.tif","henspa_index.tif")
##outPlus14.save("WaterPurif_henspa_combined_index.tif")
##
### Water Purification and sedwre
##outPlus15 = Plus("waterpur_i.tif","sedwre_index.tif")
##outPlus15.save("WaterPurif_sedwre_combined_index.tif")
##
### Carbon Storage and boboli
##outPlus16 = Plus("carbon_i.tif","boboli_index.tif")
##outPlus16.save("CarbonStor_boboli_combined_index.tif")
##
### Carbon Storage and easmea
##outPlus17 = Plus("carbon_i.tif","easmea_index.tif")
##outPlus17.save("CarbonStor_easmea_combined_index.tif")
##
### Carbon Storage and graspa
##outPlus18 = Plus("carbon_i.tif","graspa_index.tif")
##outPlus18.save("CarbonStor_graspa_combined_index.tif")
##
### Carbon Storage and henspa
##outPlus19 = Plus("carbon_i.tif","henspa_index.tif")
##outPlus19.save("CarbonStor_henspa_combined_index.tif")
##
### Carbon Storage and sedwre
##outPlus20 = Plus("carbon_i.tif","sedwre_index.tif")
##outPlus20.save("CarbonStor_sedwre_combined_index.tif")

