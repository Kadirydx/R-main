library(shiny)
library(rhandsontable)

shinyUI(
  navbarPage("MTT", id = "ana_menu",
             
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
             ),
             
             tabPanel("Veri İncele",
                      fluidPage(
                        tags$style(HTML("
          .handsontable td {
            text-align: center;
            font-size: 11px;
          }
          .htCore {
            width: 100% !important;
          }
        ")),
                        fluidRow(
                          column(
                            width = 6,
                            checkboxGroupInput(
                              inputId = "secili_mttler",
                              label = "3 zaman noktası tamamlanmış MTT numaraları:",
                              choices = NULL
                            ),
                            uiOutput("grid_tables_ui")
                          ),
                          column(
                            width = 6,
                            h4("Buraya analiz, grafik vs. gelecek"),
                            # plotOutput("my_plot") gibi şeyler eklenebilir
                          )
                        )
                      )
             )
  )
)
