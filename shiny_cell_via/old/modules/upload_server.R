upload_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$data_preview <- renderTable({
      req(input$file)
      read.csv(input$file$datapath, stringsAsFactors = FALSE)
    })
  })
}
