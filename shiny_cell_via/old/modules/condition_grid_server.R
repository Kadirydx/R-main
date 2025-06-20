condition_grid_server <- function(input, output, session, id_prefix = "") {
  wells <- as.vector(outer(LETTERS[1:8], 1:12, paste0))
  renkler <- c(
    "none" = "#ffffff",
    "control" = "#d0e4f7",
    "treatment" = "#d9f7d0",
    "replicate" = "#f7ecd0"
  )
  
  values <- reactiveValues(
    condition_df = data.frame(
      well = wells,
      group = rep("none", length(wells)),
      stringsAsFactors = FALSE
    )
  )
  
  # Her kuyucuk için UI
  observe({
    for (well in wells) {
      local({
        w <- well
        output[[paste0("well_", w)]] <- renderUI({
          current <- values$condition_df$group[values$condition_df$well == w]
          bg <- renkler[current]
          div(style = paste0("background-color:", bg, "; padding:2px; border-radius:4px;"),
              selectInput(inputId = w, label = NULL,
                          choices = names(renkler), selected = current,
                          width = "80px"))
        })
      })
    }
  })
  
  # Her input'u dinle
  observe({
    for (well in wells) {
      observeEvent(input[[well]], {
        values$condition_df$group[values$condition_df$well == well] <- input[[well]]
      }, ignoreInit = TRUE)
    }
  })
  
  # Toplu atama
  observeEvent(input[[paste0(id_prefix, "all_none")]], {
    values$condition_df$group <- "none"
  })
  observeEvent(input[[paste0(id_prefix, "all_control")]], {
    values$condition_df$group <- "control"
  })
  observeEvent(input[[paste0(id_prefix, "all_treatment")]], {
    values$condition_df$group <- "treatment"
  })
  observeEvent(input[[paste0(id_prefix, "all_replicate")]], {
    values$condition_df$group <- "replicate"
  })
  
  # Şablon yükle
  observeEvent(input[[paste0(id_prefix, "cond_upload")]], {
    file <- input[[paste0(id_prefix, "cond_upload")]]
    req(file)
    df <- tryCatch(read.csv(file$datapath, stringsAsFactors = FALSE), error = function(e) NULL)
    if (!is.null(df) && all(c("well", "group") %in% colnames(df))) {
      values$condition_df <- df
      showNotification("Şablon yüklendi ✅", type = "message")
    } else {
      showNotification("Geçersiz dosya formatı ❌", type = "error")
    }
  })
  
  # Kaydet tuşu: şu anlık sadece bildirim
  observeEvent(input[[paste0(id_prefix, "grid_kaydet")]], {
    showNotification("Tablo güncellendi (uygulama içinde).", type = "message")
  })
  
  return(values)
}

