login_server <- function(id, user_name, allowed_users) {
  moduleServer(id, function(input, output, session) {
    
    observeEvent(input$giris, {
      if (nzchar(input$login_name)) {
        if (input$login_name %in% allowed_users) {
          user_name(input$login_name)
        } else {
          showNotification("Gecersiz kullanıcı adı!", type = "error")
        }
      } else {
        showNotification("Lütfen bir isim girin!", type = "warning")
      }
    })
    
    output$giris_adi <- renderText({
      req(user_name())
      paste("Giriş yapıldı:", user_name())
    })
  })
}
