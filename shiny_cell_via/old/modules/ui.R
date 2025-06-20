library(shiny)

source("modules.R")

# ---- login_ui ----
login_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("name"), "İsminizi girin:"),
    actionButton(ns("login_btn"), "Giriş Yap"),
    textOutput(ns("status"))
  )
}

# ---- condition_grid_ui ----
condition_grid_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h4("96 Well Grid"),
    fluidRow(
      column(2, actionButton(ns("all_control"), "Tümünü Control")),
      column(2, actionButton(ns("all_none"), "Tümünü None")),
      column(2, actionButton(ns("all_replicate"), "Tümünü Replicate"))
    ),
    tags$hr(),
    fluidRow(
      column(1, ""),
      lapply(1:12, function(j) column(1, strong(j)))
    ),
    lapply(1:8, function(i) {
      row <- LETTERS[i]
      fluidRow(
        column(1, strong(row)),
        lapply(1:12, function(j) {
          well <- paste0(row, j)
          column(1, uiOutput(ns(paste0("well_", well))))
        })
      )
    })
  )
}

# ---- CSS ----
logout_css <- tags$style(HTML("
  #logout_btn {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 9999;
  }
"))

# ---- UI ----
shinyUI(
  navbarPage("Shiny Uygulaması", id = "ana_menu",
             tabPanel("Login",
                      fluidPage(
                        logout_css,
                        titlePanel("Login"),
                        sidebarLayout(
                          sidebarPanel(login_ui("login1")),
                          mainPanel(textOutput("login_status"))
                        )
                      )
             )
  )
)
