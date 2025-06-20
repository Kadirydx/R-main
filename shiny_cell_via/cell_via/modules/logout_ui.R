logout_tab_ui <- tabPanel("cıkıs",
                          fluidPage(
                            h3("Oturumu sonlandırmak için çıkış yapın."),
                            actionButton("cikis", "Çıkış Yap", class = "btn btn-danger")
                          )
)
