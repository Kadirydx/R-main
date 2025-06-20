condition_grid_ui <- function(id_prefix = "") {
  fluidPage(
    titlePanel("96 Well Condition Grid"),
    fluidRow(
      column(12,
             fluidRow(
               column(2, strong("Toplu İşlem:")),
               column(10,
                      actionButton(paste0(id_prefix, "all_none"), "Tümünü None"),
                      actionButton(paste0(id_prefix, "all_control"), "Tümünü Control"),
                      actionButton(paste0(id_prefix, "all_treatment"), "Tümünü Treatment"),
                      actionButton(paste0(id_prefix, "all_replicate"), "Tümünü Replicate")
               )
             ),
             tags$hr(),
             fluidRow(
               column(6, fileInput(paste0(id_prefix, "cond_upload"), "Şablon Yükle (.csv)")),
               column(6, actionButton(paste0(id_prefix, "grid_kaydet"), "Condition Tablosunu Kaydet"))
             )
      )
    ),
    fluidRow(
      column(1, ""),
      lapply(1:12, function(j) column(1, strong(j)))
    ),
    lapply(1:8, function(i) {
      row <- LETTERS[i]
      fluidRow(
        column(1, strong(row)),
        lapply(1:12, function(j) {
          well_id <- paste0(row, j)
          column(1, uiOutput(paste0(id_prefix, "well_", well_id)))
        })
      )
    })
  )
}
