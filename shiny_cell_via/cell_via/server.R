library(shiny)

# Modül server dosyaları
source("modules/login_server.R", local = TRUE)
browser()
source("modules/form_server.R", local = TRUE)
browser()
source("modules/upload_server.R", local = TRUE)
browser()
source("modules/logout_server.R", local = TRUE)
browser()

# Yetkili kullanıcılar
allowed_users <- c("Ali", "Ayse", "Mehmet", "Fatma")
browser()

shinyServer(function(input, output, session) {
  
  user_name <- reactiveVal(NULL)
  browser()
  
  # Giri ekranı çalıtır
  login_server("login", user_name, allowed_users)
  browser()
  # Giri yapıldığında sekmeleri ekle
  observeEvent(user_name(), {
    req(user_name())
    browser()
    insertTab("ana_menu", form_tab_ui, target = "Giris", position = "after")
    insertTab("ana_menu", upload_tab_ui, target = "MTT Formu", position = "after")
    insertTab("ana_menu", logout_tab_ui, target = "Veri Yükle", position = "after")
    browser()
    updateTabsetPanel(session, "ana_menu", selected = "MTT Formu")
  })
  browser()
  # Çıkı yapıldığında her eyi sıfırla
  logout_server("logout", user_name)
  browser()
  form_server("form")
  browser()
  upload_server("upload")
  browser()
  })
