library(shiny)
library(readxl)

`%||%` <- function(a, b) if (!is.null(a)) a else b

shinyServer(function(input, output, session) {
  
  dir.create("user_data", showWarnings = FALSE)
  
  # Grid UI
  output$cond_table <- renderUI({
    tagList(
      tags$div(
        id = "js_grid_container",
        style = "display: grid; grid-template-columns: repeat(13, 1fr); gap: 4px;"
      ),
      tags$script(src = "condition_grid.js")
    )
  })
  
  # Kuyucuk inputları (dinleme)
  observe({
    lapply(LETTERS[1:8], function(row) {
      lapply(1:12, function(col) {
        well_id <- paste0("well_", row, col)
        observeEvent(input[[well_id]], {
          print(paste(well_id, ":", input[[well_id]]))
        }, ignoreInit = TRUE)
      })
    })
  })
  
  # 📊 Veri önizleme (satır ve sütun başlıklarıyla)
  output$data_preview <- renderTable({
    req(input$data_file)
    
    excel_data <- read_excel(input$data_file$datapath, col_names = FALSE)
    
    if (!(nrow(excel_data) == 9 && ncol(excel_data) == 13)) {
      return(data.frame("Uyarı" = "Dosya 9 satır × 13 sütun olmalı (1 başlık + 8 veri satırı, 1 başlık + 12 sütun)"))
    }
    
    row_names <- as.character(unlist(excel_data[-1, 1]))
    col_names <- as.character(unlist(excel_data[1, -1]))
    abs_data <- as.data.frame(excel_data[-1, -1])
    colnames(abs_data) <- col_names
    rownames(abs_data) <- row_names
    
    abs_data$Row <- rownames(abs_data)
    abs_data <- abs_data[, c("Row", col_names)]
    abs_data
  })
  
  # Meta çıktılar
  output$meta_out_isim <- renderText({ "İsim girilmedi (giriş kaldırıldı)" })
  output$meta_out_mtt_hour <- renderText({ req(input$meta_in_mtt_hour); paste("Saat:", input$meta_in_mtt_hour) })
  output$meta_out_mtt_num <- renderText({ req(input$meta_in_mtt_num); paste("Numara:", input$meta_in_mtt_num) })
  output$meta_out_date <- renderText({ req(input$meta_in_date); paste("Tarih:", format(input$meta_in_date, "%d-%m-%Y")) })
  
  # Meta özet
  output$meta_out_summary <- renderText({
    path <- "mtt_kayitlari.csv"
    if (!file.exists(path)) return("Henüz kayıt yok.")
    df <- read.csv(path, stringsAsFactors = FALSE)
    paste(apply(df, 1, function(row) {
      paste(row["MTT_Number"], "-", row["MTT_Hour"], "-", row["Date"], "-", row["File_Name"])
    }), collapse = "\n")
  })
  
  # 🟡 KAYDET işlemi
  observeEvent(input$kaydet, {
    req(input$data_file)
    req(input$meta_in_mtt_num, input$meta_in_mtt_hour, input$meta_in_date)
    
    # ⬇️ Excel verisi (satır + sütun başlıklı)
    excel_data <- read_excel(input$data_file$datapath, col_names = FALSE)
    
    # 📏 Boyut kontrolü (9x13)
    if (!(nrow(excel_data) == 9 && ncol(excel_data) == 13)) {
      showNotification(
        paste0(
          "❌ Yüklenen dosya beklenen boyutta değil.\n",
          "🧾 Beklenen: 9 satır (1 başlık + 8 veri) × 13 sütun (1 başlık + 12 veri)\n",
          "📦 Gelen: ", nrow(excel_data), " satır × ", ncol(excel_data), " sütun"
        ),
        type = "error"
      )
      return()
    }
    
    # 📊 Absorbans veri kısmını ayıkla
    abs_data <- as.data.frame(excel_data[-1, -1])
    rownames(abs_data) <- as.character(unlist(excel_data[-1, 1]))
    colnames(abs_data) <- as.character(unlist(excel_data[1, -1]))
    
    # 🔢 Sayısallık kontrolü
    if (!all(sapply(abs_data, is.numeric))) {
      showNotification("📉 Tüm hücreler sayısal (absorbans) olmalı!", type = "error")
      return()
    }
    
    # 📁 Meta bilgiler
    mtt_num <- input$meta_in_mtt_num
    mtt_hour <- input$meta_in_mtt_hour
    mtt_date <- format(input$meta_in_date, "%Y-%m-%d")
    file_tag <- paste0("MTT", mtt_num, "_", mtt_hour, "_", mtt_date)
    
    # 💾 Excel dosyasını kaydet
    file.copy(input$data_file$datapath, file.path("user_data", paste0(file_tag, "_raw.xlsx")), overwrite = TRUE)
    
    # 🧪 Grid condition verisi
    wells <- expand.grid(Row = LETTERS[1:8], Col = 1:12, stringsAsFactors = FALSE)
    wells$WellID <- paste0(wells$Row, wells$Col)
    wells$Value <- sapply(wells$WellID, function(id) input[[paste0("well_", id)]] %||% "none")
    
    # 📝 Meta dosyası
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
    
    # 📈 Long format condition kayıt
    long_data <- cbind(meta_info[rep(1, nrow(wells)), 1:3], wells[, c("WellID", "Value")])
    write.csv(long_data, file.path("user_data", paste0(file_tag, "_long.csv")), row.names = FALSE)
    
    showNotification("✅ Kayıt tamamlandı: Veri ve condition table kaydedildi.", type = "message")
  })
})
