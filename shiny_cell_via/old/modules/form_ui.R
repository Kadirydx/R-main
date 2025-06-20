form_tab_ui <- function(id) {
  ns <- NS(id)
  tabPanel("MTT Formu",
           sidebarLayout(
             sidebarPanel(
               textInput(ns("form_input"), "Bir şey yazın:"),
               actionButton(ns("form_gonder"), "Kaydet")
             ),
             mainPanel(
               h4("Yazdığınız:"),
               textOutput(ns("form_cikti"))
             )
           )
  )
}
