library(raster)
library(sp)

grid <- raster("C:/Chicago_Grasslands/Bird_Abundance_Model_Outputs/natural_areas.tif")

library(igraph)

g_clump <- clump(grid, filename="C:/Chicago_Grasslands/Bird_Abundance_Model_Outputs/natural_areas_clump.tif", directions=8, gaps=FALSE)

g_clump
