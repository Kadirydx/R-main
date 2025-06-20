login_tab_ui <- tabPanel("Giris",
                         fluidPage(
                           titlePanel("Giris Paneli"),
                           sidebarLayout(
                             sidebarPanel(
                               textInput("login_name", "İsminizi girin:"),
                               actionButton("giris", "Giris Yap")
                             ),
                             mainPanel(
                               h4("Durum:"),
                               textOutput("giris_adi")
                             )
                           )
                         )
)
