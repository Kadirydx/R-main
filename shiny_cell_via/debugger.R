# Kayıt klasörünü temizle
unlink("user_data", recursive = TRUE)

# Meta kayıt dosyasını sil
if (file.exists("mtt_kayitlari.csv")) file.remove("mtt_kayitlari.csv")

# Yeniden oluştur
dir.create("user_data")

rm(list = ls())         # tüm değişkenleri temizle
.rs.restartR()          # RStudio kullanıyorsan, oturumu temizle (veya R'ı kapatıp aç)

if (file.exists(".RData")) file.remove(".RData")

library(readxl)
source("functions/extract_abs_data.R")
source("functions/save_uploaded_data.R")

raw_df <- read_excel("samle_data/20250417 (24hour).xlsx", col_names = FALSE)
abs_data <- extract_abs_data(raw_df)

print(rownames(abs_data))  # A–H
print(colnames(abs_data))  # 1–12
print(abs_data["C", "6"])  # Sayı gelmeli, NA değil
