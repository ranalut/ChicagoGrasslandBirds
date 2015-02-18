gridSample.max <- function (xy, r, n = 1, chess = "", all.data)
{
    if (inherits(xy, "Spatial")) {
        xy <- coordinates(xy)
    }
    r <- raster(r)
    cell <- cellFromXY(r, xy)
    uc <- unique(na.omit(cell))
    chess <- trim(chess)
    if (chess != "") {
        chess <- tolower(chess)
        stopifnot(chess %in% c("black", "white"))
        nc <- ncol(r)
        if (nc%%2 == 1) {
            if (chess == "white") {
                tf <- 1:ceiling(ncell(r)/2) * 2 - 1
            }
            else {
                tf <- 1:ceiling((ncell(r) - 1)/2) * 2
            }
        }
        else {
            nr <- nrow(r)
            row1 <- 1:(ceiling(nr/2)) * 2 - 1
            row2 <- row1 + 1
            row2 <- row2[row2 <= nr]
            if (chess == "white") {
                col1 <- 1:(ceiling(nc/2)) * 2 - 1
                col2 <- col1 + 1
                col2 <- col2[col2 <= nc]
            }
            else {
                col1 <- 1:(ceiling(nc/2)) * 2
                col2 <- col1 - 1
                col1 <- col1[col1 <= nc]
            }
            cells1 <- cellFromRowColCombine(r, row1, col1)
            cells2 <- cellFromRowColCombine(r, row2, col2)
            tf <- c(cells1, cells2)
        }
        uc <- uc[uc %in% tf]
    }
    cell <- cellFromXY(r, xy)
	# xy <- cbind(xy, cell, runif(nrow(xy))) # Original
	xy <- cbind(xy, cell, all.data)
    xy <- na.omit(xy)
    # xy <- unique(xy) # Original, dropped b/c we are evaluating repeat samples
    # xy <- xy[order(xy[, 4]), ] # Original
	xy <- xy[order(xy[, 'HOW_MANY_ATLEAST'],decreasing=TRUE), ]
    pts <- matrix(nrow = 0, ncol = 2)
    for (u in uc) {
        ss <- subset(xy, xy[, 3] == u)
        # pts <- rbind(pts, ss[1:min(n, nrow(ss)), 1:2]) # Original
		pts <- rbind(pts, ss[1:min(n, nrow(ss)), ]) # Keep the whole dataframe
    }
    return(pts)
}
