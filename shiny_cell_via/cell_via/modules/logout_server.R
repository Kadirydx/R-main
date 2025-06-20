logout_server <- function(id, user_name) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$cikis, {
      # Sekmeleri kaldır
      removeTab("ana_menu", "MTT Formu")
      removeTab("ana_menu", "Veri Yükle")
      removeTab("ana_menu", "cıkıs")
      
      # Login sekmesini geri ekle
      insertTab("ana_menu", login_tab_ui, position = "before")
      
      # Kullanıcıyı sıfırla
      user_name(NULL)
      
      updateTabsetPanel(session, "ana_menu", selected = "Giris")
    })
  })
}
