# R code for multitamporal analysis

install.packages("ggridges") # this is needed to create ridgeline plots 
library(terra)
library(imageRy)
library(viridis)
library(ggridges)

# Listing the data
im.list()

EN_01 = im.import( "EN_01.png" )
EN_01 = flip(EN_01)
plot(EN_01)

EN_13 = im.import( "EN_13.png" )
EN_13 = flip(EN_13)
plot(EN_13)

im.multiframe(1,2)
plot(EN_01)
plot(EN_13)

ENdif = EN_01[[1]] - EN_13[[1]]
plot(ENdif)
plot(ENdif, col=inferno(100))

#-----

Greenland ice melt 

gr = im.import("greenland")
grdif = gr[[1]] - gr[[4]]
grdif = gr[[4]] - gr[[1]] #2015-2000
plot(grdif)
# All the yellow parts are those in which there is a higher value in 2015

# Ridgeline plots 
im.ridgeline(gr, scale=1)
im.ridgeline(gr, scale=2)
im.ridgeline(gr, scale=2, palette="inferno")
im.ridgeline(gr, scale=3, palette="inferno")

im.list()

# Exercise: import the NDVI data from Sentinel 
NDVI=im.import("Sentinel2_NDVI")
im.ridgeline(NDVI, scale=2)

# Changing names 
# sources: Sentinel2_NDVI_2020-02-21.tif                   
#          Sentinel2_NDVI_2020-05-21.tif                    
#          Sentinel2_NDVI_2020-08-01.tif                     
#          Sentinel2_NDVI_2020-11-27.tif

names(NDVI) = c("02_Feb", "05_May", "08_Aug", "11_Nov")
im.ridgeline(NDVI, scale=2)
im.ridgeline(NDVI, scale=2, palette="mako")

pairs(NDVI)

plot(NDVI[[1]], NDVI[[2]])
# y= x # may y, feb x 
# y = a + bx
# a=0, b=1
# y = a + bx = 0 + 1x = x 

abline(0,1, col="red")

plot(NDVI[[1]], NDVI[[2]], xlim=c(-0.3,0.9), ylim=c(-0.3,0.9))

im.multiframe(1,3)
plot(NDVI[[1]])
plot(NDVI[[2]])
plot(NDVI[[1]], NDVI[[2]], xlim=c(-0.3,0.9), ylim=c(-0.3,0.9))

