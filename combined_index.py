import arcpy
from arcpy import env
from arcpy.sa import *

arcpy.CheckOutExtension("Spatial")

env.workspace = "C:/Chicago_Grasslands/Bird_Abundance_Model_Outputs"

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
##    inRaster = species + "_nass_v36w_mean_2_cal.tif"
##    outDivide = Divide(inRaster, constant)
##    outDivide.save(species + "_index.tif")
##
# Create new, individual rasters for each ecosystem service valuation dataset.
esList = ["FloodContr","Groundwate","WaterPurif","CarbonStor"]

for es in esList:
    inRas = "C:/Chicago_Grasslands/GIV2_3_EcosystemServiceValues1_COPY_albers.tif"
    outRas = Lookup(inRas, es)
    outRas.save(es + "_index.tif")

# Create combined indices:
# Flood Control and boboli
outPlus1 = Plus("FloodContr_index.tif","boboli_index.tif")
outPlus1.save("FloodContr_boboli_combined_index.tif")

# Flood Control and easmea
outPlus2 = Plus("FloodContr_index.tif","easmea_index.tif")
outPlus2.save("FloodContr_easmea_combined_index.tif")

# Flood Control and graspa
outPlus3 = Plus("FloodContr_index.tif","graspa_index.tif")
outPlus3.save("FloodContr_graspa_combined_index.tif")

# Flood Control and henspa
outPlus4 = Plus("FloodContr_index.tif","henspa_index.tif")
outPlus4.save("FloodContr_henspa_combined_index.tif")

# Flood Control and sedwre
outPlus5 = Plus("FloodContr_index.tif","sedwre_index.tif")
outPlus5.save("FloodContr_sedwre_combined_index.tif")

# Groundwater Recharge and boboli
outPlus6 = Plus("Groundwate_index.tif","boboli_index.tif")
outPlus6.save("Groundwate_boboli_combined_index.tif")

# Groundwater Recharge and easmea
outPlus7 = Plus("Groundwate_index.tif","easmea_index.tif")
outPlus7.save("Groundwate_easmea_combined_index.tif")

# Groundwater Recharge and graspa
outPlus8 = Plus("Groundwate_index.tif","graspa_index.tif")
outPlus8.save("Groundwate_graspa_combined_index.tif")

# Groundwater Recharge and henspa
outPlus9 = Plus("Groundwate_index.tif","henspa_index.tif")
outPlus9.save("Groundwate_henspa_combined_index.tif")

# Groundwater Recharge and sedwre
outPlus10 = Plus("Groundwate_index.tif","sedwre_index.tif")
outPlus10.save("Groundwate_sedwre_combined_index.tif")

# Water Purification and boboli
outPlus11 = Plus("WaterPurif_index.tif","boboli_index.tif")
outPlus11.save("WaterPurif_boboli_combined_index.tif")

# Water Purification and easmea
outPlus12 = Plus("WaterPurif_index.tif","easmea_index.tif")
outPlus12.save("WaterPurif_easmea_combined_index.tif")

# Water Purification and graspa
outPlus13 = Plus("WaterPurif_index.tif","graspa_index.tif")
outPlus13.save("WaterPurif_graspa_combined_index.tif")

# Water Purification and henspa
outPlus14 = Plus("WaterPurif_index.tif","henspa_index.tif")
outPlus14.save("WaterPurif_henspa_combined_index.tif")

# Water Purification and sedwre
outPlus15 = Plus("WaterPurif_index.tif","sedwre_index.tif")
outPlus15.save("WaterPurif_sedwre_combined_index.tif")

# Carbon Storage and boboli
outPlus16 = Plus("CarbonStor_index.tif","boboli_index.tif")
outPlus16.save("CarbonStor_boboli_combined_index.tif")

# Carbon Storage and easmea
outPlus17 = Plus("CarbonStor_index.tif","easmea_index.tif")
outPlus17.save("CarbonStor_easmea_combined_index.tif")

# Carbon Storage and graspa
outPlus18 = Plus("CarbonStor_index.tif","graspa_index.tif")
outPlus18.save("CarbonStor_graspa_combined_index.tif")

# Carbon Storage and henspa
outPlus19 = Plus("CarbonStor_index.tif","henspa_index.tif")
outPlus19.save("CarbonStor_henspa_combined_index.tif")

# Carbon Storage and sedwre
outPlus20 = Plus("CarbonStor_index.tif","sedwre_index.tif")
outPlus20.save("CarbonStor_sedwre_combined_index.tif")

