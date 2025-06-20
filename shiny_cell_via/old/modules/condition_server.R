library(shiny)
library(DT)

condition_tab_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    create_condition_df <- function() {
      wells <- outer(LETTERS[1:8], 1:12, paste0)
      data.frame(
        well = as.vector(wells),
        group = rep("none", 96),
        stringsAsFactors = FALSE
      )
    }
    
    cond_data <- reactiveValues(df = create_condition_df())
    
    output$cond_table <- DT::renderDataTable({
      DT::datatable(cond_data$df, editable = TRUE, rownames = FALSE) %>%
        DT::formatStyle(
          "group",
          target = "row",
          backgroundColor = DT::styleEqual(
            c("control", "treatment", "replicate", "none"),
            c("lightblue", "lightgreen", "lightyellow", "white")
          )
        )
    })
    
    observeEvent(input$cond_table_cell_edit, {
      info <- input$cond_table_cell_edit
      i <- info$row
      j <- info$col
      v <- info$value
      cond_data$df[i, j] <<- v
    })
    
    return(reactive(cond_data$df))
  })
}
