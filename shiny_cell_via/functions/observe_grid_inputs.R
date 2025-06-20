observe_grid_inputs <- function() {
  lapply(LETTERS[1:8], function(row) {
    lapply(1:12, function(col) {
      well_id <- paste0("well_", row, col)
      observeEvent(input[[well_id]], {
        print(paste(well_id, ":", input[[well_id]]))
      }, ignoreInit = TRUE)
    })
  })
}