#MAXENT demo
library(devtools)
install_github('johnbaums/rmaxent')
library(rmaxent)

occ_file <- system.file('ex/bradypus.csv', package='dismo')
occ <- read.table(occ_file, header=TRUE, sep=',')[,-1]

library(raster)
pred_files <- list.files(system.file('ex', package='dismo'), '\\.grd$', full.names=TRUE )
predictors <- stack(pred_files)

library(dismo)

#set java file location
Sys.setenv(JAVA_HOME = "C:\\Program Files (x86)\\Eclipse Adoptium\\jdk-8.0.462.8-hotspot\\bin\\java.exe")

library(rJava)
me <- maxent(predictors, occ, factors='biome', args=c('hinge=false', 'threshold=false')) #why disable hinge and threshold features???

#predicting the model to the model-fitted data
prediction <- project(me, predictors)

#plot results
library(rasterVis)
library(viridis)
levelplot(prediction$prediction_logistic, margin=FALSE, col.regions=viridis, at=seq(0, 1, len=100)) +
  latticeExtra::layer(sp.points(SpatialPoints(occ), pch=20, col=1))        
