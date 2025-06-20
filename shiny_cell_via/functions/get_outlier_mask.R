get_outlier_mask <- function(df, rf = 1.5) {
  if (is.null(rownames(df))) rownames(df) <- LETTERS[1:nrow(df)]
  if (is.null(colnames(df))) colnames(df) <- as.character(1:ncol(df))
  
  vec <- as.vector(as.matrix(df))
  vec_clean <- vec[!is.na(vec)]
  
  Q1 <- quantile(vec_clean, 0.25)
  Q3 <- quantile(vec_clean, 0.75)
  IQR_val <- Q3 - Q1
  lower <- Q1 - rf * IQR_val
  upper <- Q3 + rf * IQR_val
  
  outlier_mask_vec <- vec < lower | vec > upper
  outlier_mask <- matrix(outlier_mask_vec, nrow = nrow(df), ncol = ncol(df))
  dimnames(outlier_mask) <- dimnames(df)
  
  return(outlier_mask)
}
