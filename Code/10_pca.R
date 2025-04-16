# R code for performing Principal Component Analysis 

library(imageRy)
library(terra)

im.list()

sent=im.import("sentinel.png")
sent=flip(sent)
plot(sent)

sent = c(sent[[1]],sent[[2]],sent[[3]])
plot(sent)

# NIR = band 1
# red = band 2
# green = band 3

sentpca = im.pca(sent)

tot = 71.807726 + 52.081665 +  5.692673
71.807726 * 100 / tot

sentpca = im.pca(sent, n_samples=100000)

sdpca = focal(sentpca[[1]], w=c(3,3), fun="sd")
plot(sdpca)

pairs(sent) # crea grafico con le correlazioni
