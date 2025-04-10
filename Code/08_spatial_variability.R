# R code for calculating spatial variability 

library(terra)
library(imageRy)
library(viridis)
library(patchwork)
# install.packages("RStoolbox")
library(RStoolbox)

# 24 26 25 

# https://www.cuemath.com/data/variance-and-standard-deviation/

media = (24+26+25) / 3 

num = (24-media)^2 + (26-media)^2 + (25-media)^2
den = 3

varianza = num/den 
stdev = sqrt(varianza)
#  0.8164966

sd(c(24,26,25))
# 1 

sd(c(24,26,25,49))
# 12.02775

mean(c(24,26,25))
mean(c(24,26,25,49))

#----

im.list()

sent = im.import("sentinel.png")
sent = flip(sent)

# band 1 = NIR
# band 2 = red 
# band 3 = green 

# Exercise plot the image in RGB with the NIR ontop of the red component 
im.plotRGB(sent, r=1, g=2, b=3)

# Exercise: make three plots with NIR ontop of each component: r, g, b
im.multiframe(1,3)
im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(sent, r=2, g=1, b=3)
im.plotRGB(sent, r=3, g=2, b=1)


#----

nir = sent[[1]]

# Exercise: plot the nir band with the inferno color ramp palette
dev.off()
plot(nir, col=inferno(100))
sd3 = focal(nir, w=c(3,3), fun="sd")
plot(sd3)

im.multiframe(1,2)
im.plotRGB(sent, r=1, g=2, b=3)
plot(sd3)

# Exercise: calculate standard deviation of the nir band with a moving window of 5x5 pixels
sd5 = focal(nir, w=c(5,5), fun="sd")
plot(sd5)

im.multiframe(1,2)
plot(sd3)
plot(sd5)

# Exercise: use ggplot to plot the standard deviation
im.ggplot(sd3)

# Exercise: plot the two sd maps (3 and 5) one beside the other with ggplot
p1 = im.ggplot(sd3)
p2 = im.ggplot(sd5)
p1 + p2

# Plot the original nir and stdev 
p3 = im.ggplot(nir)
p3 + p1 

p3 = ggRGB(sent, r=1, g=2, b=3)


# What to do in case of huge images 
sent = im.import("sentinel.png")
sent = flip(sent)

ncell(sent) * nlyr(sent) 

# 794 * 798
# 2534448

senta = aggregate(sent, fact=2)
ncell(senta) * nlyr(senta) 
# 633612

senta5 = aggregate(sent, fact=5)
ncell(senta5) * nlyr(senta5) 
# 101760

# Exercise: make a multiframe and plot in RGB the three images 
im.multiframe(1,3)
im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(senta, 1 ,2 ,3)
im.plotRGB(senta5, 1, 2, 3)

# Calculating standard deviation
nira = senta[[1]]
sd3a = focal(nira, w=c(3,3), fun="sd")

# Exercise: calculating the standard deviation for the factor 5 image
nira5 = senta[[1]]
sd3a5 = focal(nira5, w=c(3,3), fun="sd")

sd5a5 = focal(nira5, w=c(5,5), fun="sd")

im.multiframe(1,2)
plot(sd5a5)
plot(sd3a)

im.multiframe(2,2)
plot(sd3)
plot(sd3a)
plot(sd3a5)
plot(sd5a5)

p1 = im.ggplot(sd3)
p2 = im.ggplot(sd3a)
p3 = im.ggplot(sd3a5)
p4 = im.ggplot(sd5a5)

p1 + p2 + p3 + p4

im.multiframe(2,2)
plot(sd3, col=plasma(100))
plot(sd3a, col=plasma(100))
plot(sd3a5, col=plasma(100))
plot(sd5a5, col=plasma(100))

# Variance
# nir 
var3 = sd3^2

plot(var3)

im.multiframe(1,2)
plot(sd3)
plot(var3)

sd5 = focal(nir, w=c(5,5), fun="sd")
var5 = sd5^2
plot(sd5)
plot(var5)




