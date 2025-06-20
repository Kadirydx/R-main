library(shiny)

# Modülleri içe aktar
source("modules/login_ui.R")
source("modules/form_ui.R")
source("modules/form_server.R")
source("modules/condition_grid_ui.R")
source("modules/condition_ui.R")
source("modules/condition_server.R")
source("modules/upload_ui.R")
source("modules/logout_ui.R")
source("modules/logout_server.R")

# Kullanıcılar
allowed_users <- c("Selin", "Kadir", "Ayberk")

# UI
ui <- navbarPage("MTT Uygulaması",
                 id = "ana_menu",
                 login_tab_ui  # Başlangıçta sadece giriş sekmesi
)

# Server
server <- function(input, output, session) {
  user_name <- reactiveVal(NULL)
  
  # Giriş kontrolü
  observeEvent(input$giris, {
    req(input$login_name)
    if (input$login_name %in% allowed_users) {
      user_name(input$login_name)
      removeTab("ana_menu", target = "Giris")
      
      insertTab("ana_menu", form_tab_ui, position = "before")
      insertTab("ana_menu", upload_tab_ui, position = "after")
      insertTab("ana_menu", condition_tab_ui("condition_tab"), position = "after")
      insertTab("ana_menu", condition_grid_ui(""), position = "after")
      insertTab("ana_menu", logout_tab_ui, position = "after")
      
      updateTabsetPanel(session, "ana_menu", selected = "MTT Formu")
    } else {
      showNotification("Geçersiz kullanıcı!", type = "error")
    }
  })
  
  # Modülleri başlat
  form_server("form")
  condition_tab_server("condition_tab")
  logout_server("logout", user_name)
}

shinyApp(ui, server)
