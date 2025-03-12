# Code for calculating spectral indices in R 

library(imageRy) # beloved package developed at unibo
library(terra)
library(viridis)

im.list()

mato1992 = im.import( "matogrosso_l5_1992219_lrg.jpg"  )
mato1992 = flip(mato1992)
plot(mato1992)

# 1 = NIR 
# 2 = red
# 3 = green 

im.plotRGB(mato1992, r=1, g=2, b=3)
im.plotRGB(mato1992, r=2, g=1, b=3)
im.plotRGB(mato1992, r=2, g=3, b=1)
