library(shiny)

shinyUI(
  navbarPage("Form Uygulaması",
             
             # Sekme 1: Kullanıcı Bilgileri
             tabPanel("Kullanıcı Bilgileri",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("meta_in_isim", "Who are you:", choices = c("Selin", "Kadir", "Ayberk")),
                          selectInput("meta_in_mtt_hour", "MTT Hour:", choices = c("24H", "48H", "72H")),
                          numericInput("meta_in_mtt_num", "MTT Number?", value = 0, min = 0),
                          dateInput("meta_in_date", "Date (dd-mm-yyyy):", format = "dd-mm-%Y"),
                          actionButton("kaydet", "Go")
                        ),
                        mainPanel(
                          h4("Kaydedilen Bilgiler:"),
                          textOutput("meta_out_isim"),
                          textOutput("meta_out_mtt_hour"),
                          textOutput("meta_out_mtt_num"),
                          textOutput("meta_out_date"),
                          h4("Özet:"),
                          verbatimTextOutput("meta_out_summary")
                        )
                      )
             ),
             
             # Sekme 2: Data Yükleme
             tabPanel("MTT Data Yükle",
                      sidebarLayout(
                        sidebarPanel(
                          fileInput("data_file", "MTT dosyasını yükle (.csv ya da .xlsx)", 
                                    accept = c(".csv", ".xlsx"))
                        ),
                        mainPanel(
                          h4("Yüklenen Verinin Önizlemesi:"),
                          tableOutput("data_preview")
                        )
                      )
             )
  )
)
