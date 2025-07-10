#Codice R esame

#Confronto tra immagini precedenti e successive all’incendio che ha interessato il Carso nell’estate 2022. 

#Per prima cosa si caricano in R i pacchetti necessari 

library(terra) #pacchetto utilizzato per l'analisi di dati spaziali con dati vettoriali e raster 
library(imageRy) #pacchetto per manipolare, visualizzare ed esportare immagini raster 
library(viridis) #pacchetto per le palette di colori
library(ggridges) #pacchetto per la creazione di plot ridgeline
library(ggplot2) #pacchetto per la creazione di grafici a barre
library(patchwork) #pacchetto per l'unione dei grafici creati con ggplot2

#Vengono poi importate e visualizzate le immagini 

setwd("C:/Users/magda/OneDrive/Documents/UNIBO/telerilevamento/esame/") #impostazione della working directory da cui importare l'immagine salvata 

preincendio= rast("preincendio_2022.tif") #per importare e nominare il raster
plot(preincendio) #per visualizzare l'immagine
plotRGB(preincendio, r = 1, g = 2, b = 3, stretch = "lin", main = "pre_incendio") #per visualizzare l'immagine a veri colori
dev.off() #per chiudere il pannello di visualizzazione delle immagini

postincendio= rast("postincendio_2022.tif") 
plot(postincendio) 
plotRGB(postincendio, r = 1, g = 2, b = 3, stretch = "lin", main = "post_incendio") 
dev.off()

im.multiframe(1,2)  #funzione che apre un pannello multiframe che permette di vedere le 2 immagini una affianco all'altra 
plotRGB(preincendio, r = 1, g = 2, b = 3, stretch = "lin", main = "pre_incendio")  #prima immagine da inserire nel pannello
plotRGB(postincendio, r = 1, g = 2, b = 3, stretch = "lin", main = "post_incendio")  #seconda immagine da inserire nel pannello
dev.off()

im.multiframe(2,4) 
plot(preincendio[[1]], col = magma(100), main = "Pre - Banda 1") #si specifica la banda, il colore e il titolo
plot(preincendio [[2]], col = magma(100), main = "Pre - Banda 2")
plot(preincendio [[3]], col = magma(100), main = "Pre - Banda 3")
plot(preincendio [[4]], col = magma(100), main = "Pre - Banda 8")

plot(postincendio[[1]], col = magma(100), main = "Post - Banda 1")
plot(postincendio [[2]], col = magma(100), main = "Post - Banda 2")
plot(postincendio [[3]], col = magma(100), main = "Post - Banda 3")
plot(postincendio [[4]], col = magma(100), main = "Post - Banda 8")
dev.off()

#Si passa al calcolo degli indici spaziali per valutare quanto la vegetazione sia stata compromessa a seguito dell’incendio

#INDICE DVI 
DVIpre = im.dvi(preincendio, 4, 1)  #per calcolare il DVI (immagine, banda NIR, banda R)
plot(DVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))  #per visualizzare graficamente il risultato, si specificano titolo e colore
dev.off()

DVIpost = im.dvi(postincendio, 4, 1) 
plot(DVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()

im.multiframe(1,2)  #per creare pannello multiframe con il DVI pre e post incendio
plot(DVIpre, stretch = "lin", main = "DVIpre", col=inferno(100))  
plot(DVIpost, stretch = "lin", main = "DVIpost", col=inferno(100))
dev.off()

#INDICE NDVI 
NDVIpre = im.ndvi(preincendio, 4, 1)   #per calcolare l'NDVI
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))  #per visualizzare graficamente il risultato, si specificano titolo e colore 
dev.off()
 
NDVIpost = im.ndvi(postincendio, 4, 1)  
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()
 
im.multiframe(1,2)  #per creare pannello multiframe con l'NDVI pre e post incendio
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()

im.multiframe(2,2) #per creare pannello con 2 righe e 2 colonne 
plot(DVIpre, stretch = "lin", main = "DVIpre", col=inferno(100))
plot(DVIpost, stretch = "lin", main = "DVIpost", col=inferno(100))
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()


#Per visualizzare e comprendere meglio l’impatto viene svolta un’analisi multitemporale 

incendio_diff = preincendio[[1]] - postincendio[[1]]  #per calcolare differenza nella banda del rosso tra pre e post incendio
incendio_diff_ndvi = NDVIpre - NDVIpost  #per calcolare differenza NDVI

im.multiframe(1,2)  #per creare pannello multiframe per visualizzare entrambe le immagini
plot(incendio_diff, main = "Incendio: differenza banda del rosso")
plot(incendio_diff_ndvi, main = "Incendio: differenza NDVI")
dev.off()

incendio_rl = c(NDVIpre, NDVIpost)  #per creare vettore che ha come elementi le due immagini NDVI
names(incendio_rl) =c("NDVI_pre", "NDVI_post")  #per creare vettore con i nomi relativi alle immagini

im.ridgeline(incendio_rl, scale=1, palette="viridis")  #per creare grafico ridgelines 
dev.off()

preincendio_class = im.classify(NDVIpre, num_clusters=2)  #per classificare l'immagine           
postincendio_class = im.classify(NDVIpost, num_clusters=2)

im.multiframe(2,2)
plot(preincendio_class, main = "Pixel NDVI pre incendio")
plot(postincendio_class, main = "Pixel NDVI post incendio")
plot(preincendio_class - postincendio_class, main = "Differenza NDVI pre e post incendio")
dev.off()

perc_pre_c = freq(preincendio_class) * 100 / ncell(preincendio_class)  #per calcolare la frequenza percentuale di ciascun cluster
perc_pre_c  #per visualizzare la frequenza percentuale

    layer           value           count
1   0.0002251492    0.0002251492    19.25048
2   0.0002251492    0.0004502983    80.74952

perc_post_c = freq(postincendio_class) * 100 / ncell(postincendio_class)
perc_post_c

      layer           value           count
1     0.0002251492    0.0002251492    25.70821
2     0.0002251492    0.0004502983    74.29179

NDVI = c("elevato", "basso") #per creare vettore con i nomi dei due cluster
pre = c(80.75, 19.25)  #per creare vettore con le percentuali per il prima e il dopo incendio
post = c(74.30, 25.70)
tabout = data.frame(NDVI, pre, post)  #per creare dataframe con i valori di NDVI per pre e post e visualizzarlo
tabout

        NDVI         pre            post 
    1   elevato      80.75          74.30
    2   basso        19.25          25.70

ggplotpreincendio = ggplot(tabout, aes(x=NDVI, y=pre, fill=NDVI, color=NDVI)) + geom_bar(stat="identity") + ylim(c(0,100))  #per creare ggplot con i valori di NDVI ottenuti 
ggplotpostincendio = ggplot(tabout, aes(x=NDVI, y=post, fill=NDVI, color=NDVI)) + geom_bar(stat="identity") + ylim(c(0,100))
ggplotpreincendio + ggplotpostincendio + plot_annotation(title = "Valori NDVI (espressi in superficie) nell'area interessata dall’incendio")    #per unire i grafici crati, si specifica il titolo 
dev.off()
