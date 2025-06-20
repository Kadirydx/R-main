save_uploaded_data <- function(abs_data, file_info, meta_inputs, well_inputs) {
  print("save_uploaded_data calıstı")
  `%||%` <- function(a, b) if (!is.null(a)) a else b

  mtt_num   <- meta_inputs$mtt_num
  mtt_hour  <- meta_inputs$mtt_hour
  mtt_date  <- format(meta_inputs$mtt_date, "%Y-%m-%d")
  file_tag  <- paste0("MTT", mtt_num, "_", mtt_hour, "_", mtt_date)

  dir.create("user_data", showWarnings = FALSE)
  file.copy(file_info$datapath, file.path("user_data", paste0(file_tag, "_raw.xlsx")), overwrite = TRUE)

  wells <- expand.grid(Row = LETTERS[1:8], Col = 1:12, stringsAsFactors = FALSE)
  wells$WellID <- paste0(wells$Row, wells$Col)

  wells$Condition <- sapply(wells$WellID, function(id) {
    val <- well_inputs[[paste0("well_", id)]]
    if (is.null(val) || val == "none" || val == "") "NA" else val
  })

  col_names <- colnames(abs_data)
  row_names <- rownames(abs_data)

  wells$Absorbance <- mapply(function(r, c) {
    r_char <- as.character(r)
    c_label <- as.character(c)

    if (!(r_char %in% row_names) || !(c_label %in% col_names)) return(NA)
    val <- abs_data[r_char, c_label]
    if (is.null(val) || is.na(val)) return(NA)
    suppressWarnings(round(as.numeric(val), 4))
  }, wells$Row, wells$Col)

  meta_info <- data.frame(
    MTT_Number = mtt_num,
    MTT_Hour   = mtt_hour,
    Date       = mtt_date,
    File_Name  = paste0(file_tag, "_raw.xlsx"),
    stringsAsFactors = FALSE
  )

  meta_path <- "mtt_kayitlari.csv"
  if (file.exists(meta_path)) {
    old_meta <- read.csv(meta_path, stringsAsFactors = FALSE)
    full_meta <- rbind(old_meta, meta_info)
  } else {
    full_meta <- meta_info
  }
  write.csv(full_meta, meta_path, row.names = FALSE)

  long_data <- data.frame(
    MTT_Number  = rep(mtt_num, nrow(wells)),
    MTT_Hour    = rep(mtt_hour, nrow(wells)),
    Date        = rep(mtt_date, nrow(wells)),
    WellID      = wells$WellID,
    Condition   = wells$Condition,
    Absorbance  = wells$Absorbance,
    stringsAsFactors = FALSE
  )

  write.csv(long_data, file.path("user_data", paste0(file_tag, "_long.csv")), row.names = FALSE)

  return(TRUE)
}
