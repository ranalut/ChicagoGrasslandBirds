
# INTRODUCTION ########################################
This repository is for the Chicago Grassland Birds habitat suitability modeling project.

# SCRIPTS #####################################
Below is an outline of the scripts and their functions:

# Processing NASS data layers to extract percent cover measures at multiple spatial scales:
focal.proportions.r

# Processing Landsat data layers to extract mean band values at multiple spatial scales:
landsat.focal.mean.r

# Atmospheric correction of landsat imagery and cloud estraction
landsat.processing.r

# Assembling spatial layers into raster stacks for nass and landsat datasets
load.data.r
species.data.r

# Construction of Boosted Regressing Tree models:
brt.models.r





# ARCHIVAL SCRIPTS #####################################
The project has been completed in multiple rounds and has included some abandoned methods.
As a result some of the scripts are archival.
These include:

all.survey.pts.r
clip_predictions.r
gme_neighborhood_stats.txt
gme_script_point_raster.txt
landsat_7_files.r
make_covariate_layers.r
make_landsat8_layers_for_extraction.r