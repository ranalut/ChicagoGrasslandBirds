# http://permalink.gmane.org/gmane.comp.lang.r.geo/16739
# Hi Prajjwal,

# I think the best approach in your case is to create a new, updated netcd file instead of adding a dimension to
# an existing file. By using the ncdf4 package to create the file, you have lots of options to customize names
# and descriptions of variables and dimensions.

# At the end of this message you can see the code that I use to create a netcdf file with global coverage at 0.5
# degree resolution based obviously on a netcdf with the same features. The resulting netcdf will contain
# one level "slice" and 12 time "slices". One detail about netcdf files is that the coordinates of point
# refers to the center of the point and not to the edge. That's why I start longitude at -179.75 instead of -180
# and longitude at 89.75 instead of 90.

# If the resulting file looks like longitude and latitude are inverted, you must transpose the data when
# converting raster to matrix:
# data <- t(as.matrix(r))

# I hope it helps,

# Thiago.

#--------------------------------------------------------begin of code-----------------------------------------------------

# Load required packages
library(raster)
library(ncdf4)

# Load your data
r <- raster('old_file.nc')

# Here's the trick: convert your data to a matrix
data <- as.matrix(r)

# Now that we have the data we need, make output file in the correct format

# Create dimensions lon, lat, level and time
dim_lon  <- ncdim_def('longitude', 'degrees_east', seq(-179.75,179.75,by=0.5))
dim_lat  <- ncdim_def('latitude', 'degrees_north', seq(89.75,-89.75,by=-0.5))
dim_lev  <- ncdim_def('level', 'level/index', 1)
dim_time <- ncdim_def('time', "years since 1990-01-01", 1:12, unlim=T)

# Create a new variable "precipitation", create netcdf file, put updated contents on it and close file
# Note that variable "data" is the actual contents of the original netcdf file
var_out <- ncvar_def('precipitation', 'mm/day', list(dim_lon,dim_lat,dim_lev,dim_time), 9.e20)
ncid_out <- nc_create('updated_netcdf.nc', var_out)
ncvar_put(ncid_out, var_out, data, start=c(1, 1, 1, 1), count=c(720, 360, 1, 12))
nc_close(ncid_out)