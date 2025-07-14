## Esame di Telerilevamento Geoecologico in R - 2025
#### Agnese Dal Bò
> ##### matricola n. 1187303

# Incendio sul Carso: analisi pre e post impatto 🔥

## Indice 📑
1. Introduzione e obiettivi dello studio
2. Raccolta delle immagini 
3. Analisi delle immagini
4. Indici spettrali
5. Analisi multitemporale
6. Risultati e conclusioni

## 1. Introduzione e obiettivi dello studio 🎯

Nell'estate del 2022 la zona del Carso tra Italia e Slovenia è stata interessata da vasti incendi che hanno prodotto enormi danni e ingenti perdite a livello di biodiversità. Uno studio condotto dalle Università di Udine e Trieste parla addirittura di quasi 4.100 ettari di superficie forestale inceneriti e circa il 50% della biomassa presente sul territorio interessato dalle fiamme andata perduta.
Gli incendi si sono sviluppati a partire dal 19 luglio del 2022 nell'area di Doberdò del Lago. 
Per valutare gli impatti a seguito di questo incendio sono quindi state utilizzate delle **immagini satellitari** provenienti dall'area compresa tra **Doberdò del Lago** e **San Martino del Carso**. Per valutare i cambiamenti pre e post impatto sono state scelte immagini tra il **01 giugno** e il **01 luglio 2022** (per il pre) e tra il **31 luglio** e il **31 agosto 2022** (per il post). 

<div align="center">
  <img width="1004" height="380" alt="image" src="https://github.com/user-attachments/assets/b6d3f2fd-ca97-4bd8-b030-73ca5241bc95" />
</div>  
  
<div align="center">
  <img width="1004" height="380" alt="image" src="https://github.com/user-attachments/assets/d349ffb6-81cc-4043-9869-757f0c7108ab" />
</div>  

> *L'area di studio*


## 2. Raccolta delle immagini 🌐
Le immagini satellitari utilizzate provengono dal sito di [**Google Earth Engine**](https://earthengine.google.com/).

Per ottenere le immagini dell'area di interesse prima dell'incendio è stato utilizzato il codice fornito durante il corso in **JavaScript**. 
Tale codice riporta una collezione di immagini che vanno **dal 01/06/2022 al 01/07/2022**, selezionando solo immagini con una *copertura nuvolosa <20%* e le *bande relative al rosso, verde, blu e NIR*.

<details>
<summary>codice JavaScript per le immagine pre incendio </summary>
  
``` JavaScript
// ==============================================
// Sentinel-2 Surface Reflectance - Cloud Masking and Visualization
// https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
// ==============================================

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Keep only pixels where both cloud and cirrus bits are 0
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  // Apply the cloud mask and scale reflectance values (0–10000 ➝ 0–1)
  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load and Prepare the Image Collection
// ==============================================

// Load Sentinel-2 SR Harmonized collection (atmospherical correction already done)
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(carso)
                   .filterDate('2022-06-01', '2022-07-01')              // Filter by date                                 
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the carso overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(carso);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(carso, 10); // Zoom to the carso

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  band: ['B4', 'B3', 'B2', 'B8'],  // NIR color
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  band: ['B4', 'B3', 'B2', 'B8'], 
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2', 'B8']),  // Select NIR band
  description: 'preincendio',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'preincendio',
  region: carso,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});
```
</details>

Per le immagini relative al post incendio è stato invece preso in considerazione il periodo dal **31/07/2022 al 31/08/2022**.

<details>
<summary>codice JavaScript per le immagine post incendio </summary>
  
``` JavaScript
// ==============================================
// Sentinel-2 Surface Reflectance - Cloud Masking and Visualization
// https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
// ==============================================

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Keep only pixels where both cloud and cirrus bits are 0
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  // Apply the cloud mask and scale reflectance values (0–10000 ➝ 0–1)
  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Load and Prepare the Image Collection
// ==============================================

// Load Sentinel-2 SR Harmonized collection (atmospherical correction already done)
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(carso)
                   .filterDate('2022-07-31', '2022-08-31')              // Filter by date                                 
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // Only images with <20% cloud cover
                   .map(maskS2clouds);                                  // Apply cloud masking

// Print number of images available after filtering
print('Number of images in collection:', collection.size());

// ==============================================
// Create a median composite from the collection
// Useful when the carso overlaps multiple scenes or frequent cloud cover
// ==============================================
var composite = collection.median().clip(carso);

// ==============================================
// Visualization on the Map
// ==============================================

Map.centerObject(carso, 10); // Zoom to the carso

// Display the first image of the collection (GEE does this by default)
Map.addLayer(collection, {
  band: ['B4', 'B3', 'B2', 'B8'],  // NIR color
  min: 0,
  max: 0.3
}, 'First image of collection');

// Display the median composite image
Map.addLayer(composite, {
  band: ['B4', 'B3', 'B2', 'B8'], 
  min: 0,
  max: 0.3
}, 'Median composite');

// ==============================================
// Export to Google Drive
// ==============================================

// Export the median composite
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2', 'B8']),  // Select NIR band
  description: 'postincendio',
  folder: 'GEE_exports',                        // Folder in Google Drive
  fileNamePrefix: 'postincendio',
  region: carso,
  scale: 10,                                    // Sentinel-2 resolution
  crs: 'EPSG:4326',
  maxPixels: 1e13
});
```
</details>


## 3. Analisi delle immagini 🖥️
Una volta scaricate le immagini satellitari queste sono state importate su **R** per poter fare un'analisi dettagliata. 

Per lo studio sono stati usati e caricati in R i seguenti pacchetti: 
``` r
library(terra) #pacchetto utilizzato per l'analisi di dati spaziali con dati vettoriali e raster 
library(imageRy) #pacchetto per manipolare, visualizzare ed esportare immagini raster 
library(viridis) #pacchetto per le palette di colori
library(ggridges) #pacchetto per la creazione di plot ridgeline
library(ggplot2) #pacchetto per la creazione di grafici a barre
library(patchwork) #pacchetto per l'unione dei grafici creati con ggplot2
```
Per prima cosa è stata settata la working directory e poi sono state importate e visualizzate le immagini. 
```r
setwd("C:/Users/magda/OneDrive/Documents/UNIBO/telerilevamento/esame/") #impostazione della working directory da cui importare l'immagine salvata 
preincendio= rast("preincendio_2022.tif") #per importare e nominare il raster
plot(preincendio) #per visualizzare l'immagine
im.plotRGB(preincendio, r = 1, g = 2, b = 3, title = "pre_incendio") #per visualizzare l'immagine a veri colori
dev.off() #per chiudere il pannello di visualizzazione delle immagini
```
<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/8b577d9b-3254-4435-a9be-83b7ba143558" />
</div>

> *L'immagine nelle 4 bande*

<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/25d213d7-f9fe-4dbe-86b8-a1f63069239b" />
</div>

> *L'immagine a veri colori*

Lo stesso è stato fatto per l'immagine post incendio. 

```r
postincendio= rast("postincendio_2022.tif") 
plot(postincendio) 
im.plotRGB(postincendio, r = 1, g = 2, b = 3, title = "post_incendio") 
dev.off() 
```
<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/7e10fe2b-705b-4974-a074-7045ac3140d0" />
</div>

> *L'immagine nelle 4 bande*

<div align="center">
 <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/02f16bf9-8237-4b5e-9ea2-200388010499" />
</div>

> *L'immagine a veri colori*

È stato poi creato un pannello multiframe per visualizzare le immagini affiancate.

```r
im.multiframe(1,2)  #funzione che apre un pannello multiframe che permette di vedere le 2 immagini una affianco all'altra 
im.plotRGB(preincendio, r = 1, g = 2, b = 3, title = "pre_incendio")  #prima immagine da inserire nel pannello
im.plotRGB(postincendio, r = 1, g = 2, b = 3, title = "post_incendio")  #seconda immagine da inserire nel pannello
dev.off()
```
<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/940f9af9-e526-4525-9e35-d0e06f91a179" />
</div>

> *Le immagini a veri colori pre e post incendio*

> [!NOTE]
> *Nella seconda immagine è chiaramente visibile la zona interessata dall'incendio in alto a destra.*

E poi un multiframe per le 4 bande.

```r
im.multiframe(2,4) 
plot(preincendio[[1]], col = magma(100), main = "Pre - Banda 1") #viene specificata  la banda, il colore e il titolo
plot(preincendio [[2]], col = magma(100), main = "Pre - Banda 2")
plot(preincendio [[3]], col = magma(100), main = "Pre - Banda 3")
plot(preincendio [[4]], col = magma(100), main = "Pre - Banda 8")

plot(postincendio[[1]], col = magma(100), main = "Post - Banda 1")
plot(postincendio [[2]], col = magma(100), main = "Post - Banda 2")
plot(postincendio [[3]], col = magma(100), main = "Post - Banda 3")
plot(postincendio [[4]], col = magma(100), main = "Post - Banda 8")
dev.off()
```
<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/f967f06b-4cd8-44d7-aa93-855cc57a195c" />
</div>

> [!NOTE]
> *Anche in questo caso, nella banda 8 corrispondente al NIR si nota la differenza nella zona in alto a destra.*


## 4. Indici spaziali 🧮
Per valutare l'impatto dell'incendio sono stati calcolati gli indici **DVI** e **NDVI**. Il primo (Difference Vegetation Index) misura la densità e la biomassa della vegetazione. Più è alto il valore del DVI, più abbondante è la vegetazione. 
Si calcola come: **$$DVI = NIR - Red$$**, dove NIR è la riflettanza nel vicino infrarosso e Red la riflettanza nella banda rossa. 
Mentre l'NDVI (Normalized Difference Vegetation Index) serve per valutare la salute della vegetazione. 
Si calcola come: **$NDVI = \frac{(NIR - Red)}{(NIR + Red)}$**.
Valori < 0 rappresentano acque, neve, o superfici artificiali, valori tra 0 e 0.3 indicano aree con scarsa copertura vegetale, valori tra 0.3 e 0.6 corrispondono a praterie, arbusteti o colture agricole in fase di crescita, tra 0.6 e 0.9 indicano foreste dense e rigogliose. 

Per calcolare gli indici in **R** sono state usate le seguenti funzioni provenienti dal pacchetto **imageRy**:

```r
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
```
<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/caff8fde-9e54-4554-8737-f25244aeecd9" />
</div>

> [!NOTE]
> *Dall'immagine risulta già una certa differenza specialmente nella zona in altro a destra.*

Lo stesso è stato fatto per l'**NDVI**

```r
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
```
<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/4bd84640-c6ca-4ecb-8403-8e80646cf817" />
</div>

>[!NOTE]
> *Anche qui nel post incendio l'immagine diventa più scura, indice che l'NDVI ha valori più vicini allo 0 e che quindi la vegetazione è stata compromessa.*

Per visualizzare entrambi gli indici, prima e dopo l'incendio è stato creato un pannello multiframe: 

```r
im.multiframe(2,2) #per creare pannello con 2 righe e 2 colonne 
plot(DVIpre, stretch = "lin", main = "DVIpre", col=inferno(100))
plot(DVIpost, stretch = "lin", main = "DVIpost", col=inferno(100))
plot(NDVIpre, stretch = "lin", main = "NDVIpre", col=inferno(100))
plot(NDVIpost, stretch = "lin", main = "NDVIpost", col=inferno(100))
dev.off()
```
<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/a4e5b5b8-bca8-4612-b3c1-7c756982e6d7" />
</div>


## 5. Analisi multitemporale ⌛
Per visualizzare meglio l'impatto dell'incendio è stata calcolata la **differenza tra le immagini del prima e del dopo** per quanto riguarda la **banda del rosso** e i valori di **NDVI**.

```r
incendio_diff = preincendio[[1]] - postincendio[[1]]  #per calcolare differenza nella banda del rosso tra pre e post incendio
incendio_diff_ndvi = NDVIpre - NDVIpost  #per calcolare differenza NDVI

im.multiframe(1,2)  #per creare pannello multiframe per visualizzare entrambe le immagini
plot(incendio_diff, main = "Incendio: differenza banda del rosso")
plot(incendio_diff_ndvi, main = "Incendio: differenza NDVI")
dev.off()
```
<div align="center">
 <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/d10b193c-3d70-4a72-b75b-9ed328b230c7" />
</div>

>[!NOTE]
>*La seconda immagine mostra chiaramente una macchia di colore diverso in alto a destra, indice di un grande impatto dell'incendio sulla vegetazione.*

Per visualizzare graficamente la frequenza dei pixel di ogni immagine per ciascun valore di NDVI è stata poi fatta un'**analisi ridgeline** dei valori di **NDVI nel pre e nel post incendio**. Questa permette appunto di creare due **curve di distribuzione** con cui diventa possibile osservare eventuali variazioni nel tempo della frequenza di NDVI.

```r  
incendio_rl = c(NDVIpre, NDVIpost)  #per creare vettore che ha come elementi le due immagini NDVI
names(incendio_rl) =c("NDVI_pre", "NDVI_post")  #per creare vettore con i nomi relativi alle immagini

im.ridgeline(incendio_rl, scale=1, palette="viridis")  #per creare grafico ridgelines 
dev.off()
```
<div align="center">
  <img width="490" height="550" alt="image" src="https://github.com/user-attachments/assets/5fda8e0d-99cc-4a55-b811-9573ad403df2" />
</div>

>[!NOTE]
>*Il grafico ridgeline mostra la distribuzione dei valori di NDVI, per quanto riguarda l'andamento prima dell'incendio si vede come i valori di NDVI >0.75 sono molto maggiori rispetto al grafico successivo all'incendio. Nel secondo grafico inoltre aumentano i valori di NDVI più bassi e ciò conferma l'impatto subito.*

Per visualizzare la **variazione percentuale di NDVI** nell'area interessata dall'incendio è stato creato un **grafico a barre** tramite il pacchetto **ggplot2**. Questo permette di suddividere tutti i pixel di ciascuna immagine in **due classi** a seconda dei loro valori, in questo caso valori elevati di NDVI (vegetazione sana) e bassi (vegetazione scarsa/assente), per poi confrontarli graficamente.

```r
preincendio_class = im.classify(NDVIpre, num_clusters=2)  #per classificare l'immagine           
postincendio_class = im.classify(NDVIpost, num_clusters=2)

im.multiframe(2,2)
plot(preincendio_class, main = "Pixel NDVI pre incendio")
plot(postincendio_class, main = "Pixel NDVI post incendio")
plot(preincendio_class - postincendio_class, main = "Differenza NDVI pre e post incendio")
dev.off()
```
<div align="center">
  <img width="550" height="490" alt="image" src="https://github.com/user-attachments/assets/a1bb4346-807e-4df0-8669-088eb6b813f1" />
</div>

>[!NOTE]
> *I pixel sono stati suddivisi in due classi (1 e 2), e paragonando queste immagini a quelle NDVI dell'area si vede che la classe 1 corrisponde a valori bassi di NDVI e quella 2 a valori elevati.*

```r
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
```
<div align="center">
  <img width="490" height="550" alt="image" src="https://github.com/user-attachments/assets/72f12889-59be-4fdd-aa56-28a5d1f1cf71" />
</div>

>[!NOTE]
>  *I valori di NDVI elevati (indici di una vegetazione sana) sono diminuiti nel post incendio rispetto al prima, mentre quelli bassi sono aumentati.*

Per capire nel passato più remoto come la vegetazione ha risposto è stata ricavata allo stesso modo un'immagine satellitare dell'area colpita dall'incendio ma un anno dopo (**31/07/2023, 31/08/2023**). Replicando le stesse analisi quello che si è ottenuto è che un anno dopo la situazione è tornata simile a quella prima dell'impatto, per alcuni aspetti è anche migliorata. Ciò è dovuto probabilmente al fatto che l'area colpita dall'incendio nel 2022 presentava già una vegetazione secca a causa delle elevate temperature che da molto interessavano la zona. 

<div align="center">
  <img width="490" height="550" alt="image" src="https://github.com/user-attachments/assets/7cb80ec8-6325-4718-accc-f1ea90138451" />
</div>

>[!NOTE]
> *Si noti come i valori di NDVI del 2023 siano tornati simili a quelli della situazione pre impatto, se non addirittura aumentati per quanto riguarda i valori elevati (indice di una vegetazione sana) e diminuiti per quanto riguarda quelli bassi (indice di una vegetazione compromessa).*

## 6. Risultati e conclusioni ☑️
Le analisi hanno confermato quanto atteso: l'incendio ha compromesso parte della vegetazione. 
La visualizzazione delle immagini satelliatri e quelle relative agli indici di vegetazione **DVI** e **NDVI** mostrano chiaramente la zona interessata dall'incendio, caratterizzata da una vegetazione assente e da valori degli indici inferiori. Le piante sane infatti assorbono la luce rossa utilizzata nel processo fotosintetico e riflettono molta luce nell'infrarosso vicino. Quando la vegetazione viene colpita dall'incendio aumenta l'assorbimento nel rosso e diminuisce la riflettanza nel NIR e ciò determina valori inferiori. 
L'analisi quantitativa ha poi evidenziato come i valori elevati del NIR siano diminuiti **da 80% a 74%** e quelli bassi invece siano aumentati **da 19% a 25%** a seguito dell'incendio.

Il confronto con un'immagine satellitare del 2023, un anno dopo l'incendio, ha comunque mostrato come l'area abbia ripristinato parte della vegetazione e che gli indici spettrali siano tornati come quelli pre incendio e in parte anche migliorati. 
Questo miglioramento è probabilmente dovuto al fatto che già nei mesi precedenti all'incendio la vegetazione era abbastanza secca oppure al fatto che le specie mettano in atto diverse strategie per rispondere agli impatti. Non tutte sono state infatti danneggiate allo stesso modo. Quando una specie scompare poi, altre prendono il suo posto all'interno dell'habitat allo scopo di preservare l'ecosistema. 

I cambiamenti climatici e l'aumento delle temperature porteranno a sempre più incendi in futuro. Capire come la vegetazione colpita risponde a questi fenomeni sarà fondamentale per poter intervenire, prevedere e cercare di ripristinare le aree interessate.

<div align="center">
  <img width="1004" height="669" alt="image" src="https://github.com/user-attachments/assets/6efbda88-695e-44b0-9070-232730d1bcd7" />
</div>

## Grazie per l'attenzione! 
