

library(foreign)

# it <- read.dbf('d:/chicago_grasslands/soil/soil_pts/drainagecl_cw_poly.dbf',as.is=TRUE)
# it2 <- it
# it2$drainagecl <- factor(it2$drainagecl, labels=c("Very poorly drained","Poorly drained","Somewhat poorly drained","Moderately well drained","Well drained",  "Somewhat excessively drained", "Excessively drained"))
# it2$drainagecl2 <- as.numeric(it2$drainagecl)
# it$drain_code <- it2$drainagecl2
# write.dbf(it,'d:/chicago_grasslands/soil/soil_pts/drainagecl_cw_poly.dbf')

it <- read.dbf('d:/chicago_grasslands/soil/soil_pts/hydgrpdcd_cw_poly.dbf',as.is=TRUE)
it2 <- it
# stop('cbw')
it2$hydgrpdcd <- factor(it2$hydgrpdcd, labels=c("D","C/D","B/D","A/D","C","B","A"))
it2$hydgrpdcd2 <- as.numeric(it2$hydgrpdcd)
it$hydro_code <- it2$hydgrpdcd2
write.dbf(it,'d:/chicago_grasslands/soil/soil_pts/hydgrpdcd_cw_poly.dbf')
# See http://resources.arcgis.com/en/communities/soils/02ms00000008000000.htm for explanations.
