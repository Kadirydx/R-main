library(shiny)

# UI modüllerini dahil et
source("modules/login_ui.R")
browser()
source("modules/form_ui.R", local = TRUE)
browser()
source("modules/upload_ui.R", local = TRUE)
browser()
source("modules/logout_ui.R", local = TRUE)
browser()

shinyUI(
  navbarPage("MTT Uygulaması", id = "ana_menu",
             login_tab_ui  # Başlangıçta sadece giriş sekmesi
  )
)

