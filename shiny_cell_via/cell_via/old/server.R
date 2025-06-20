library(shiny)

shinyServer(function(input, output) {
  
  # Reaktif yapı
  values <- reactiveValues(kullanici = NULL)
  
  observeEvent(input$kaydet, {
    # Kullanıcıdan gelen bilgileri sakla
    values$kullanici <- list(
      isim     = input$meta_in_isim,
      mtt_hour = input$meta_in_mtt_hour,
      mtt_num  = input$meta_in_mtt_num,
      mtt_date = input$meta_in_date
    )
    
    # CSV'ye yazılacak satır
    yeni_kayit <- data.frame(
      mtt_num  = values$kullanici$mtt_num,
      mtt_hour = values$kullanici$mtt_hour,
      isim     = values$kullanici$isim,
      mtt_date = format(values$kullanici$mtt_date, "%Y-%m-%d"),
      stringsAsFactors = FALSE
    )
    
    dosya_yolu <- "mtt_kayitlari.csv"
    
    if (file.exists(dosya_yolu)) {
      write.table(yeni_kayit, file = dosya_yolu, sep = ",", row.names = FALSE,
                  col.names = FALSE, append = TRUE)
    } else {
      write.table(yeni_kayit, file = dosya_yolu, sep = ",", row.names = FALSE,
                  col.names = TRUE)
    }
  })
  
  # Tek tek göstergeler
  output$meta_out_isim <- renderText({
    req(values$kullanici)
    paste("İsim:", values$kullanici$isim)
  })
  
  output$meta_out_mtt_hour <- renderText({
    req(values$kullanici)
    paste("MTT Saati:", values$kullanici$mtt_hour)
  })
  
  output$meta_out_mtt_num <- renderText({
    req(values$kullanici)
    paste("MTT Numarası:", values$kullanici$mtt_num)
  })
  
  output$meta_out_date <- renderText({
    req(values$kullanici)
    paste("Tarih:", format(values$kullanici$mtt_date, "%d-%m-%Y"))
  })
  
  # CSV'den oku ve özetle
  output$meta_out_summary <- renderText({
    dosya_yolu <- "mtt_kayitlari.csv"
    
    if (!file.exists(dosya_yolu)) {
      return("Henüz kayıt yok.")
    }
    
    df <- read.csv(dosya_yolu, stringsAsFactors = FALSE)
    
    satirlar <- apply(df, 1, function(row) {
      paste0(
        row["mtt_num"], ". MTT - ", row["mtt_hour"], " - ",
        row["isim"], " - ", format(as.Date(row["mtt_date"]), "%d-%m-%Y")
      )
    })
    
    paste(satirlar, collapse = "\n")
  })
  
})
