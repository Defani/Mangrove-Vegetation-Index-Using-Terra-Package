library(terra)

# Pemanggilan data
library(terra)

NIR   <- rast("D:/TUTORIAL R/MVI/NIR.tif")
Green <- rast("D:/TUTORIAL R/MVI/GREEN.tif")
SWIR  <- rast("D:/TUTORIAL R/MVI/SWIR.tif")

# Cek informasi raster
NIR
Green
SWIR

# Komposit false color (NIR, SWIR, Green)
plotRGB(c(NIR, SWIR, Green),
        r = 1, g = 2, b = 3,
        stretch = "lin")

#Rumus MVI
MVI <- (NIR - Green) / (SWIR - Green)


# Plot hasil MVI 

plot(MVI, 
     col = gray.colors(100), 
     main = "Mangrove Vegetation Index (MVI)")

# Terapkan threshold MVI berdasarkan Baloloy et al. (2020)
# Piksel dengan nilai >= 3.5 dianggap mangrove
Mangrove <- MVI >= 3.5

# Plot hasil klasifikasi threshold
plot(Mangrove, 
     col = c("grey", "darkgreen"),
     legend = FALSE)

# Keterangan warna:
# white     = Non-mangrove
# darkgreen = Mangrove

# Thresholding hasil MVI
Mangrove <- MVI >= 3.5

# Konversi ke faktor (kategori)
Mangrove <- as.factor(Mangrove)

# Set label kategori
levels(Mangrove) <- data.frame(value = c(0,1),
                               label = c("Non-Mangrove", "Mangrove"))

# Plot dengan legenda
plot(Mangrove, col = c("white", "darkgreen"), 
     main = "Peta Sebaran Mangrove")

#Grid
grid(lty = 2,
     lwd = 0.5,
     col = "gray50")

library(terra)

# Hitung jumlah piksel per kategori
freq_mangrove <- freq(Mangrove)

# Ukuran 1 piksel Sentinel-2 (10m x 10m)
pixel_area_m2 <- 10 * 10      # 100 m²
pixel_area_ha <- pixel_area_m2 / 10000   # 0.01 ha

# Tabel ringkas
tabel_luas <- data.frame(
  Kategori = c("Non-Mangrove", "Mangrove"),
  `Total Piksel` = freq_mangrove[,"count"],
  `Luas (Hektar)` = round(freq_mangrove[,"count"] * pixel_area_ha, 2)
)

# Print tabel
tabel_luas