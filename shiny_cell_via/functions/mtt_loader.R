load_all_mtt_numbers <- function(data_dir = "user_data") {
  files <- list.files(data_dir, pattern = "_long\\.csv$", full.names = TRUE)
  
  parsed <- do.call(rbind, lapply(files, function(path) {
    parts <- strsplit(basename(path), "_")[[1]]
    if (length(parts) >= 4) {
      return(data.frame(
        MTT = gsub("MTT", "", parts[1]),
        stringsAsFactors = FALSE
      ))
    } else {
      return(NULL)
    }
  }))
  
  if (is.null(parsed)) return(character(0))
  
  unique(parsed$MTT)
}
