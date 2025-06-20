library(shiny)

shinyUI(
  navbarPage("Shiny Uygulama", id = "ana_menu",
             
             tabPanel("Form",
                      fluidPage(
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("meta_in_mtt_hour", "MTT Hour:", choices = c("24H", "48H", "72H")),
                            numericInput("meta_in_mtt_num", "MTT Number?", value = 1, min = 1),
                            dateInput("meta_in_date", "Date (dd-mm-yyyy):", format = "dd-mm-yyyy"),
                            fileInput("data_file", "Sadece Excel dosyası", accept = ".xlsx"),
                            actionButton("kaydet", "Go")
                          ),
                          mainPanel(
                            textOutput("meta_out_isim"),
                            textOutput("meta_out_mtt_hour"),
                            textOutput("meta_out_mtt_num"),
                            textOutput("meta_out_date"),
                            verbatimTextOutput("meta_out_summary"),
                            tableOutput("data_preview")
                          )
                        )
                      )
             ),
             
             tabPanel("Condition",
                      fluidPage(
                        h3("Condition Table"),
                        uiOutput("cond_table")
                      )
             )
  )
)
