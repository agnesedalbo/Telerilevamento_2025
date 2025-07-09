## Esame di Telerilevamento Geoecologico in R - 2025
#### Agnese Dal Bò
> ##### matricola n. 1187303

# Incendio sul Carso: analisi pre e post impatto 

## Indice 
1. Introduzione e obiettivi dello studio
2. Raccolta delle immagini 
3. Analisi delle immagini
4. Indici spettrali
5. Analisi multitemporale
6. Risultati e conclusioni

## 1. Introduzione e obiettivi dello studio 
Nell'esatate del 2022 la zona del Carso tra Italia e Slovenia è stata interessata da vasti incendi che hanno prodotto enormi danni e ingenti perdite a livello di biodiversità. Uno studio condotto dalle Università di Udine e Trieste parla addirittura di quasi 4.100 ettari di superficie forestale inceneriti e circa 
il 50 per cento della biomassa presente sul territorio interessato dalle fiamme andata perduta.
Gli incendi si sono sviluppati a partire dal 19 luglio del 2022 nell'area di Doberdò del Lago. 
Per valutare gli impatti a seguito di questo incendio sono quindi state utilizzate delle **immagini satellitari** provenienti dall'area compresa tra **Doberdò del Lago** e **San Martino del Carso**. Per valutare i cambiamenti pre e post impatto sono state scelte immagini tra il **primo giugno** e il **primo luglio 2022** (per il pre) e tra il **31 luglio** e il **31 agosto 2022** (per il post). 

![image](https://github.com/user-attachments/assets/0a8025de-44b7-4975-ab5e-a94c4448007f)

![image](https://github.com/user-attachments/assets/2c75d1ea-a632-4698-8125-3d3c48df4319)

> *L'area di studio*


## 2. Raccolta delle immagini 
Le immagini satellitari utilizzate provengono dal sito di [**Google Earth Engine**](https://earthengine.google.com/).

Per ottenere le immagini dell'area di interesse prima dell'incendio è stato utilizzato il codice fornito durante il corso in **Java Script**. 
Tale codice riporta una collezione di immagini che vanno **dal 2022-06-01 al 2022-07-01**, selezionando solo immagini con una *copertura nuvolosa <20%* e le *bande relative al rosso, verde, blu e NIR*.

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

Per le immagini relative al post incendio è stato invece preso in considerazione il periodo dal **2022-07-31 al 2022-08-31**.

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

## 3. Analisi delle immagini 
Una volta scaricate le immagini satellitari queste sono state importate su **R** per poter fare un'analisi dettagliata. 

Per lo sttudio stati usati i seguenti pacchetti: 
``` r
library(terra) #pacchetto per l'utilizzo della funzione rast() per SpatRaster
library(imageRy) #pacchetto per l'utilizzo della funzione im.plotRGB() per la visualizzazione delle immagini; e le funzioni im.dvi() e im.ndvi()
library(viridis) #pacchetto che permette di creare plot di immagini con differenti palette di colori di viridis
library(ggridges) #pacchetto che permette di creare i plot ridgeline
```
Per prima cosa è stata settata la working directory e poi sono state importate e visualizzate le immagini. 
```r
setwd("C:/Users/magda/OneDrive/Documents/UNIBO/telerilevamento/esame/") #working directory in cui ho salvato il file da importare
preincendio= rast("preincendio_2022.tif") #importo e nomino il raster
plot(preincendio) #plot che mi permette di visualizzare l'immagine
plotRGB(preincendio, r = 1, g = 2, b = 3, stretch = "lin", main = "pre_incendio") #plot RGB per visualizzare l'immagine nello spettro del visibile
dev.off()
```
![image](https://github.com/user-attachments/assets/cc0f7ce6-2a5c-4342-9ed5-3fd51670301a)

> *L'immagine nelle 4 bande*

![image](https://github.com/user-attachments/assets/e4cfa80c-f999-4fb1-bc50-b4559a0cb3fc)

> *L'immagine a veri colori*


