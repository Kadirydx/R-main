# =========================================================
# 📋 Data Import and Preprocessing
# =========================================================

# 📦 Load necessary libraries
library(readr)

# ️📥 Data Import
# (Şu anda t24, t48 ve t72 aynı CSV'den geliyor. İleride farklı dosyalar kullanırsan değiştirebilirsin.)
t24 <- as.data.frame(read_csv2("data/t24.csv", col_names = FALSE))
t48 <- as.data.frame(read_csv2("data/t24.csv", col_names = FALSE))
t72 <- as.data.frame(read_csv2("data/t24.csv", col_names = FALSE))

# 🧱 Set Rows and Columns (Sabit 8x12 yapı)
rows <- LETTERS[1:8]       # Satır isimleri: A–H
cols <- as.character(1:12) # Sütun isimleri: 1–12
rep_24 <- c(2, 4:11)
rep_48 <- c(3:11)
rep_72 <- c(3:11)

# 🏷️ Satır isimlerini ayarla (ilk sütun -> rownames)
t24 <- as.matrix(t24[, -1])
rownames(t24) <- rows
colnames(t24) <- cols


t48 <- as.matrix(t48[, -1])
rownames(t48) <- rows
colnames(t48) <- cols

t72 <- as.matrix(t72[, -1])
rownames(t72) <- rows
colnames(t72) <- cols

# 🧬 Create Condition Matrix
cond_matrix <- matrix(
  data = "PBS",    # Başlangıç değeri: PBS
  nrow = 8,
  ncol = 12,
  dimnames = list(rows, cols)
)

# 💊 Assign Drug Doses (A–E satırları, 3–11 sütunlar arası)
dose_rows <- c("A", "B", "C", "D", "E")
dose_values <- c("1 uM +C", "5 uM +C", "12.5 uM +C", "25 uM +C", "50 M +C")

for (i in seq_along(dose_rows)) {
  cond_matrix[dose_rows[i], 3:11] <- dose_values[i]
}

# 🧪 Assign Special Controls
cond_matrix[, 2]      <- "BLANK(-D, -dmso, -C)"             # 2. sütun: Blank kontrol
cond_matrix["F", 3:11] <- "TRUE CONTROL(-D, -dmso, +C)"     # F satırı: True Control
cond_matrix["G", 3:11] <- "DMSO EFFECT(-D, 0.1% dmso, +C)"  # G satırı: DMSO etkisi
cond_matrix["H", 3:11] <- "DEATH DOSE(-D, 5% dmso, +C)"     # H satırı: Ölüm dozu

# 🧹 Clean environment (geçici objeleri sil)
rm(rows, cols, dose_rows, dose_values, i)

# 📦 Create Empty 3D Array
absorbance_array <- array(
  NA, 
  dim = c(nrow(cond_matrix), ncol(cond_matrix), 3),
  dimnames = list(
    rownames(cond_matrix),
    colnames(cond_matrix),
    c("absorbance_t24", "absorbance_t48", "absorbance_t72")
  )
)

# 🧩 Fill the Array Layer-by-Layer

# Katman 1: Condition bilgileri
#absorbance_array[,, "Condition"] <- as.matrix(cond_matrix)




# 📥 Array'e yerleştir
absorbance_array[,, "absorbance_t24"] <- t24
absorbance_array[,, "absorbance_t48"] <- t48
absorbance_array[,, "absorbance_t72"] <- t72

# 🧹 Temizlik

