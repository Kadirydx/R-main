form_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$form_cikti <- renderText({
      req(input$form_gonder)
      paste("Yazdığınız:", input$form_input)
    })
  })
}
