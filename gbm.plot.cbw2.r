gbm.plot.cbw2 <- function (
    gbm.object, variable.no = 0, smooth = FALSE, rug = TRUE, 
    n.plots = length(pred.names), common.scale = TRUE, write.title = TRUE, 
    y.label = "fitted function", x.label = NULL, show.contrib = TRUE, 
    plot.layout = c(3, 4),
    cat_var_lookup=NULL, # Added to add var names to plots
    ...) 
{
    if (!requireNamespace("gbm")) {
        stop("you need to install the gbm package to run this function")
    }
    requireNamespace("splines")
    gbm.call <- gbm.object$gbm.call
    gbm.x <- gbm.call$gbm.x
    pred.names <- gbm.call$predictor.names
    response.name <- gbm.call$response.name
    data <- gbm.call$dataframe
    max.plots <- plot.layout[1] * plot.layout[2]
    plot.count <- 0
    n.pages <- 1
    if (length(variable.no) > 1) {
        stop("only one response variable can be plotted at a time")
    }
    if (variable.no > 0) {
        n.plots <- 1
    }
    max.vars <- length(gbm.object$contributions$var)
    if (n.plots > max.vars) {
        n.plots <- max.vars
        warning("reducing no of plotted predictors to maximum available (", 
            max.vars, ")")
    }
    predictors <- list(rep(NA, n.plots))
    responses <- list(rep(NA, n.plots))
    for (j in c(1:n.plots)) {
        if (n.plots == 1) {
            k <- variable.no
        }
        else {
            k <- match(gbm.object$contributions$var[j], pred.names)
        }
        if (is.null(x.label)) {
            var.name <- gbm.call$predictor.names[k]
        }
        else {
            var.name <- x.label
        }
        pred.data <- data[, gbm.call$gbm.x[k]]
        response.matrix <- gbm::plot.gbm(gbm.object, k, return.grid = TRUE)
        predictors[[j]] <- response.matrix[, 1]
        if (is.factor(data[, gbm.call$gbm.x[k]])) {
            keep <- as.numeric(unique(data[,gbm.call$gbm.x[k]]))
            response.matrix[,1] <- as.numeric(response.matrix[,1])
            response.matrix <- response.matrix[response.matrix[,1] %in% 
                    keep,]
            all_names <- cat_var_lookup[[var.name]]
            # print(all_names); print(keep)
            level_names <- all_names$abrv[all_names$num %in% keep]
            # print(level_names); if (var.name=='cec_lc_mode') { stop('cbw') }
            predictors[[j]] <- response.matrix[, 1]
            predictors[[j]] <- factor(predictors[[j]], labels = level_names)
            # return(predictors[[j]])
        }
        responses[[j]] <- response.matrix[, 2] - mean(response.matrix[, 2])
        if (j == 1) {
            ymin = min(responses[[j]])
            ymax = max(responses[[j]])
        }
        else {
            ymin = min(ymin, min(responses[[j]]))
            ymax = max(ymax, max(responses[[j]]))
        }
    }
    op <- par(no.readonly = TRUE)
    par(mfrow = plot.layout,mar=c(5.1,4.1,1.1,1.1))
    for (j in c(1:n.plots)) {
        if (plot.count == max.plots) {
            plot.count = 0
            n.pages <- n.pages + 1
        }
        plot.count <- plot.count + 1
        if (n.plots == 1) {
            k <- match(pred.names[variable.no], gbm.object$contributions$var)
            if (show.contrib) {
                x.label <- paste(var.name, "  (", round(gbm.object$contributions[k, 
                  2], 1), "%)", sep = "")
            }
        }
        else {
            k <- match(gbm.object$contributions$var[j], pred.names)
            var.name <- gbm.call$predictor.names[k]
            if (show.contrib) {
                x.label <- paste(var.name, "  (", round(gbm.object$contributions[j, 
                  2], 1), "%)", sep = "")
            }
            else x.label <- var.name
        }
        if (common.scale) {
            if (is.factor(predictors[[j]])) {
            par(mar=c(5.1,7.1,1.1,1.1),las=2)
            plot(predictors[[j]], responses[[j]], ylim = c(ymin, 
                ymax), type = "l", xlab = x.label, ylab = NULL, 
                horizontal=TRUE, cex.axis=1,
                ...)
            }
            else {
                plot(predictors[[j]], responses[[j]], ylim = c(ymin, 
                ymax), type = "l", xlab = x.label, ylab = y.label, 
                ...)
            }
        }
        else {
            if (is.factor(predictors[[j]])) {
            par(mar=c(5.1,7.1,1.1,1.1),las=2)
            plot(predictors[[j]], responses[[j]], type = "l", 
                xlab = x.label, ylab = NULL, 
                horizontal=TRUE, cex.axis=0.5,
                ...)
            }
            else {
                plot(predictors[[j]], responses[[j]], type = "l", 
                xlab = x.label, ylab = y.label, ...)
            }
        }
        if (smooth & is.vector(predictors[[j]])) {
            temp.lo <- loess(responses[[j]] ~ predictors[[j]], 
                span = 0.3)
            lines(predictors[[j]], fitted(temp.lo), lty = 2, 
                col = 2)
        }
        if (plot.count == 1) {
            if (write.title) {
                title(paste(response.name, " - page ", n.pages, 
                  sep = ""))
            }
            if (rug & is.vector(data[, gbm.call$gbm.x[variable.no]])) {
                rug(quantile(data[, gbm.call$gbm.x[variable.no]], 
                  probs = seq(0, 1, 0.1), na.rm = TRUE))
            }
        }
        else {
            if (write.title & j == 1) {
                title(response.name)
            }
            if (rug & is.vector(data[, gbm.call$gbm.x[k]])) {
                rug(quantile(data[, gbm.call$gbm.x[k]], probs = seq(0, 
                  1, 0.1), na.rm = TRUE))
            }
        }
        par(mar=c(5.1,4.1,1.1,1.1))
    }
    par(op)
}

# # load('D:/Climate_2_0/grasslands_v6/breeding_models/BAIS_env_50_152_213_v5_01.rdata')
# lc_names <- read.csv('D:/Climate_2_0/landcover_classes_rehfeldt.csv',
#     stringsAsFactors = FALSE
#     )
# lc_names$name2 <- substr(
#     lc_names$name,
#     (nchar(lc_names$name)-10),
#     nchar(lc_names$name)
#     )
# last_name <- function(x) {
#     temp <- unlist(strsplit(x,' '))
#     n <- length(temp)
#     initials <- paste(substr(temp[-n],1,1),collapse='.')
#     # print(initials); stop('cbw')
#     paste(initials,temp[n],sep='.')
#     }
# lc_names$abrv <- unlist(lapply(lc_names$name, last_name))
# cec_names <- read.csv('D:/Climate_2_0/cec_classes.csv',
#     stringsAsFactors = FALSE
#     )
# stop('cbw')
# png('D:/Climate_2_0/test.png',width=1920,height=1920,pointsize=36)
# gbm.plot.cbw(
#     m,
#     n.plots=10,
#     plot.layout=c(3,4),
#     write.title=FALSE,
#     cat_var_lookup = list(veg=lc_names,cec_lc_mode=cec_names)
#     )
# dev.off()
