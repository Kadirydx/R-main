form_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$form_cikti <- renderText({
      req(input$form_gonder)
      paste("Yazdıgınız:", input$form_input)
    })
  })
}
