library(shiny)
library(readxl)
library(rhandsontable)
library(jsonlite)

`%||%` <- function(a, b) if (!is.null(a)) a else b

source("functions/extract_abs_data.R")
source("functions/save_uploaded_data.R")
source("functions/prepare_preview_data.R")
source("functions/mtt_loader.R")
source("functions/get_outlier_mask.R")

shinyServer(function(input, output, session) {
  dir.create("user_data", showWarnings = FALSE)
  final_preview_data <- reactiveVal(NULL)
  
  output$cond_table <- renderUI({
    tags$div(
      id = "js_grid_container",
      style = "display: grid; grid-template-columns: repeat(13, 1fr); gap: 4px;",
      tags$script(src = "condition_grid.js")
    )
  })
  
  observe({
    tum_mttler <- load_all_mtt_numbers()
    updateCheckboxGroupInput(session, "secili_mttler",
                             choices = tum_mttler,
                             selected = tum_mttler)
  })
  
  output$data_preview <- renderTable({
    req(input$data_file)
    result <- prepare_preview_data(input$data_file$datapath, session)
    if (!is.null(result$error)) return(data.frame("Uyarı" = result$error))
    final_preview_data(result$data)
    result$display
  }, rownames = TRUE)
  
  output$meta_out_isim     <- renderText({ "İsim girilmedi (giriş kaldırıldı)" })
  output$meta_out_mtt_hour <- renderText({ req(input$meta_in_mtt_hour); paste("Saat:", input$meta_in_mtt_hour) })
  output$meta_out_mtt_num  <- renderText({ req(input$meta_in_mtt_num);  paste("Numara:", input$meta_in_mtt_num) })
  output$meta_out_date     <- renderText({ req(input$meta_in_date); paste("Tarih:", format(input$meta_in_date, "%d-%m-%Y")) })
  
  output$meta_out_summary <- renderText({
    path <- "mtt_kayitlari.csv"
    if (!file.exists(path)) return("Henüz kayıt yok.")
    df <- read.csv(path, stringsAsFactors = FALSE)
    paste(apply(df, 1, function(row) {
      paste(row["MTT_Number"], "-", row["MTT_Hour"], "-", row["Date"], "-", row["File_Name"])
    }), collapse = "\n")
  })
  
  observeEvent(input$kaydet, {
    req(input$data_file, input$meta_in_mtt_num, input$meta_in_mtt_hour, input$meta_in_date)
    abs_data <- final_preview_data()
    if (is.null(abs_data)) {
      showNotification("⚠️ Önizleme verisi boş!", type = "error")
      return()
    }
    success <- save_uploaded_data(
      abs_data    = abs_data,
      file_info   = input$data_file,
      meta_inputs = list(
        mtt_num  = input$meta_in_mtt_num,
        mtt_hour = input$meta_in_mtt_hour,
        mtt_date = input$meta_in_date
      ),
      well_inputs = reactiveValuesToList(input)
    )
    if (success) {
      showNotification("✅ Kayıt tamamlandı!", type = "message")
    }
  })
  
  output$grid_tables_ui <- renderUI({
    req(input$secili_mttler)
    tagList(
      lapply(input$secili_mttler, function(mtt) {
        raw_files <- list.files("user_data", pattern = paste0("MTT", mtt, "_.*_raw\\.xlsx$"), full.names = TRUE)
        tagList(
          tags$h3(paste("MTT", mtt)),
          lapply(raw_files, function(path) {
            parts <- strsplit(basename(path), "_")[[1]]
            saat <- parts[2]
            id <- paste0("grid_", mtt, "_", saat)
            local({
              local_id <- id
              local_path <- path
              output[[local_id]] <- renderRHandsontable({
                raw_df <- read_excel(local_path, col_names = FALSE)
                df <- extract_abs_data(as.data.frame(raw_df))
                mask <- get_outlier_mask(df)
                row_names <- rownames(df)
                col_names <- colnames(df)
                outlier_positions <- which(mask, arr.ind = TRUE)
                outlier_wells <- apply(outlier_positions, 1, function(pos) {
                  paste0(row_names[pos[1]], col_names[pos[2]])
                })
                output[[paste0(local_id, "_outliers")]] <- renderText({
                  if (length(outlier_wells) == 0) {
                    "Outlier bulunamadı"
                  } else {
                    paste("Outlier kuyucukları:", paste(outlier_wells, collapse = ", "))
                  }
                })
                outlier_cells <- apply(outlier_positions, 1, function(pos) {
                  paste0(pos[1]-1, "_", pos[2]-1)
                })
                outlier_js_array <- toJSON(outlier_cells, auto_unbox = TRUE)
                rhandsontable(df, rowHeaders = rownames(df)) %>%
                  hot_cols(renderer = sprintf(
                    "function (instance, td, row, col, prop, value, cellProperties) {
                       var outliers = %s;
                       var cell_id = row + '_' + col;
                       td.innerText = value;
                       if (outliers.includes(cell_id)) {
                         td.style.background = 'salmon';
                       } else {
                         td.style.background = '';
                       }
                       return cellProperties;
                     }",
                    outlier_js_array
                  ))
              })
            })
            tagList(
              tags$h4(saat),
              rHandsontableOutput(outputId = id),
              verbatimTextOutput(outputId = paste0(id, "_outliers")),
              tags$hr()
            )
          })
        )
      })
    )
  })
})