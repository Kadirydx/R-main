library(shiny)
library(DT)

condition_tab_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h4("Condition Tablosu"),
    DT::dataTableOutput(ns("cond_table"))
  )
}
