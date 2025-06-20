extract_abs_data <- function(df) {
  pos <- which(df == "Abs", arr.ind = TRUE)
  if (nrow(pos) == 0) return(NULL)
  
  row_start <- pos[1, 1] + 1
  col_start <- pos[1, 2] + 1
  
  abs_block <- df[row_start:(row_start + 7), col_start:(col_start + 11)]
  
  # ✅ Önce numeric'e çevir
  abs_block <- as.data.frame(lapply(abs_block, as.numeric), check.names = FALSE)
  
  # ✅ Sonra row ve col isimlerini ayarla (önce yapsan kaybolur!)
  rownames(abs_block) <- LETTERS[1:8]
  colnames(abs_block) <- as.character(1:12)
  
  return(abs_block)
}
