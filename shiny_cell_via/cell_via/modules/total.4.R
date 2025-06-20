library(shiny)

# Yetkili kullanıcılar
allowed_users <- c("Ali", "Ayşe", "Mehmet", "Fatma")

ui <- navbarPage(
  "MTT Uygulaması",
  id = "ana_menu",
  
  # Başlangıçta sadece giriş sekmesi
  tabPanel("Giriş",
           fluidPage(
             titlePanel("Giriş Paneli"),
             sidebarLayout(
               sidebarPanel(
                 textInput("login_name", "İsminizi girin:"),
                 actionButton("giris", "Giriş Yap")
               ),
               mainPanel(
                 h4("Durum:"),
                 textOutput("giris_adi")
               )
             )
           )
  )
)

server <- function(input, output, session) {
  
  user_name <- reactiveVal(NULL)
  
  #### GİRİŞ ####
  observeEvent(input$giris, {
    if (nzchar(input$login_name)) {
      if (input$login_name %in% allowed_users) {
        user_name(input$login_name)
        
        # Login sekmesini kaldır
        removeTab("ana_menu", target = "Giriş")
        
        # MTT Formu sekmesini ekle
        insertTab("ana_menu",
                  tabPanel("MTT Formu",
                           sidebarLayout(
                             sidebarPanel(
                               textInput("form_input", "Bir şey yazın:"),
                               actionButton("form_gonder", "Kaydet")
                             ),
                             mainPanel(
                               h4("Yazdığınız:"),
                               textOutput("form_cikti")
                             )
                           )
                  ),
                  position = "before"
        )
        
        # Veri Yükle sekmesi
        insertTab("ana_menu",
                  tabPanel("Veri Yükle",
                           sidebarLayout(
                             sidebarPanel(
                               fileInput("file", "CSV dosyası seçin", accept = ".csv")
                             ),
                             mainPanel(
                               h4("Veri Önizleme:"),
                               tableOutput("data_preview")
                             )
                           )
                  ),
                  position = "after"
        )
        
        # Çıkış sekmesi
        insertTab("ana_menu",
                  tabPanel("Çıkış",
                           fluidPage(
                             h3(paste("Hoş geldin,", input$login_name)),
                             actionButton("cikis", "Çıkış Yap", class = "btn btn-danger")
                           )
                  ),
                  position = "after"
        )
        
        # MTT Formu sekmesine geç
        updateTabsetPanel(session, "ana_menu", selected = "MTT Formu")
      } else {
        showNotification("Geçersiz kullanıcı adı!", type = "error")
      }
    } else {
      showNotification("Lütfen bir isim girin!", type = "warning")
    }
  })
  
  #### ÇIKIŞ ####
  observeEvent(input$cikis, {
    # Tüm sekmeleri kaldır
    removeTab("ana_menu", target = "MTT Formu")
    removeTab("ana_menu", target = "Veri Yükle")
    removeTab("ana_menu", target = "Çıkış")
    
    # Giriş ekranını geri getir
    insertTab("ana_menu",
              tabPanel("Giriş",
                       fluidPage(
                         titlePanel("Giriş Paneli"),
                         sidebarLayout(
                           sidebarPanel(
                             textInput("login_name", "İsminizi girin:"),
                             actionButton("giris", "Giriş Yap")
                           ),
                           mainPanel(
                             h4("Durum:"),
                             textOutput("giris_adi")
                           )
                         )
                       )
              ),
              target = "MTT Uygulaması",  # boşluğa göre yerleştir
              position = "before"
    )
    
    # İsmi sıfırla
    user_name(NULL)
    updateTabsetPanel(session, "ana_menu", selected = "Giriş")
  })
  
  #### GİRİŞTEKİ DURUM METNİ ####
  output$giris_adi <- renderText({
    req(user_name())
    paste("Giriş yapıldı:", user_name())
  })
  
  #### MTT Formu çıktı ####
  output$form_cikti <- renderText({
    req(input$form_gonder)
    paste("Yazdığınız:", input$form_input)
  })
  
  #### Dosya önizleme ####
  output$data_preview <- renderTable({
    req(input$file)
    read.csv(input$file$datapath, stringsAsFactors = FALSE)
  })
}

shinyApp(ui, server)
