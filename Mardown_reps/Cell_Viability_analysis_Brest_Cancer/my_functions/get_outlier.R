get_outlier <- function(df, rf=1.5) {
  # df = data frame rf = range factor, you can change the value that you rearrange upper and lower values.
  vec <- as.vector(df)
  wells <- as.vector(outer(rownames(df), colnames(df), paste0))
  
  vec_clean <- vec[!is.na(vec)]
  Q1 <- quantile(vec_clean, 0.25)
  Q3 <- quantile(vec_clean, 0.75)
  IQR_val <- Q3 - Q1
  lower <- Q1 - rf * IQR_val
  upper <- Q3 + rf * IQR_val
  
  outlier_mask <- vec < lower | vec > upper
  outlier_wells <- wells[outlier_mask]
  
  # Uç değer yoksa 
  if (length(outlier_wells) == 0) {
    return("No outliers found")
  } else {
    return(outlier_wells)
  }
}

make_outlier_NA <- function(df, rf = 1.5, exclude_wells = NULL) {
  vec <- as.vector(df)
  wells <- as.vector(outer(rownames(df), colnames(df), paste0))
  
  vec_clean <- vec[!is.na(vec)]
  Q1 <- quantile(vec_clean, 0.25)
  Q3 <- quantile(vec_clean, 0.75)
  IQR_val <- Q3 - Q1
  lower <- Q1 - rf * IQR_val
  upper <- Q3 + rf * IQR_val
  
  outlier_mask <- vec < lower | vec > upper
  
  # Eğer exclude_wells varsa, onları outlier_mask içinden çıkar
  if (!is.null(exclude_wells)) {
    exclude_mask <- wells %in% exclude_wells
    outlier_mask[exclude_mask] <- FALSE
  }
  
  # Sonuç: sadece izin verilen uç değerler NA yapılacak
  df[outlier_mask] <- NA
  
  return(df)
}




averager <- function(df, start_col = 3, end_col = 11) {
  df <- as.data.frame(df)
  
  df <- df %>%
    mutate(mean_trial = rowMeans(select(., all_of(start_col:end_col)), na.rm = TRUE)) %>% 
    select(-all_of(start_col:end_col)) %>% 
    relocate(mean_trial, .after = start_col - 1) 
  
  df[[2]] <- mean(df[[2]], na.rm = TRUE)
  
  message("Remember to assign the result back if you want changes to persist!")
  
  df
}


get_well_addresses <- function(cond_matrix, condition_name) {
  idx <- which(cond_matrix == condition_name, arr.ind = TRUE)
  wells <- paste0(rownames(cond_matrix)[idx[, "row"]], colnames(cond_matrix)[idx[, "col"]])
  return(wells)
}
