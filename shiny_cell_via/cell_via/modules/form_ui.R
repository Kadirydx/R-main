form_tab_ui <- tabPanel("MTT Formu",
                        sidebarLayout(
                          sidebarPanel(
                            textInput("form_input", "Bir sey yazın:"),
                            actionButton("form_gonder", "Kaydet")
                          ),
                          mainPanel(
                            h4("Yazdıgınız:"),
                            textOutput("form_cikti")
                          )
                        )
)
