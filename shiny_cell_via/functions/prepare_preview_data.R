prepare_preview_data <- function(file_path, session) {
  raw_data <- readxl::read_excel(file_path, col_names = FALSE)
  abs_data <- extract_abs_data(raw_data)
  
  if (is.null(abs_data)) {
    return(list(error = "❌ Dosyada 'Abs' hücresi bulunamadı.", data = NULL, display = NULL))
  }
  
  # Highlight için: Shiny'ye renk gönder
  highlight_map <- list()
  for (r in rownames(abs_data)) {
    for (c in colnames(abs_data)[1:12]) {
      well_id <- paste0("well_", r, c)
      highlight_map[[well_id]] <- "#28a745"
    }
  }
  session$sendCustomMessage("highlightWells", highlight_map)
  
  # Asıl veri (numeric)
  abs_df <- as.data.frame(abs_data,check.names = T)
  
  # Görsel gösterim için formatlı versiyon
  display_df <- abs_df
  display_df[] <- lapply(display_df, function(x) formatC(x, format = "f", digits = 4))
  
  return(list(
    error   = NULL,
    data    = abs_df,           # sayısal veri (kayıt için)
    display = display_df        # satır isimleri korunur, sütun adları 1-12
  ))
}
