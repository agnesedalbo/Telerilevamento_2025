library(terra) #pacchetto utilizzato per l'importazione di immagini in formato .tif e altre funzioni successive
library(imageRy) #pacchetto per l'utilizzo della funzione im.plotRGB() per la visualizzazione delle immagini; e le funzioni im.dvi() e im.ndvi()
library(viridis) #pacchetto per le palette di colori
library(ggridges) #pacchetto per la creazione di plot ridgeline
library(ggplot2) #pacchetto per la creazione di grafici a barre
library(patchwork) #pacchetto per l'unione dei grafici creati con ggplot2


setwd("C:/Users/magda/OneDrive/Documents/UNIBO/telerilevamento/esame/") #impostazione della working directory da cui importare l'immagine salvata 
preincendio= rast("preincendio_2022.tif") #per importare e nominare il raster
plot(preincendio) #per visualizzare l'immagine
plotRGB(preincendio, r = 1, g = 2, b = 3, stretch = "lin", main = "pre_incendio") #per visualizzare l'immagine a veri colori
dev.off() #per chiudere il pannello di visualizzazione delle immagini



