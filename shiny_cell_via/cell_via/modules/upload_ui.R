upload_tab_ui <- tabPanel("Veri Yükle",
                          sidebarLayout(
                            sidebarPanel(
                              fileInput("file", "CSV dosyası seçin", accept = ".csv")
                            ),
                            mainPanel(
                              h4("Veri Önizleme:"),
                              tableOutput("data_preview")
                            )
                          )
)
