library(shiny)
library(readxl)

source("")

allowed_users <- c("Selin", "Kadir", "Ayberk")

# ---- login_logic ----
login_logic <- function(input, user_name, allowed_users) {
  observeEvent(input[["login1-login_btn"]], {
    name <- input[["login1-name"]]
    if (nzchar(name) && name %in% allowed_users) {
      user_name(name)
    } else {
      showNotification("Geçersiz kullanıcı!", type = "error")
    }
  })
}

# ---- condition_grid_server ----
condition_grid_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    wells <- as.vector(outer(LETTERS[1:8], 1:12, paste0))
    renkler <- c("none"="#fff", "control"="#b3d9ff", "treatment"="#d9f7d0", "replicate"="#ffe8b3")
    df <- reactiveValues(data = data.frame(well=wells, group="none", stringsAsFactors=FALSE))
    
    observe({
      for (w in wells) {
        local({
          well <- w
          output[[paste0("well_", well)]] <- renderUI({
            val <- df$data$group[df$data$well == well]
            bg <- renkler[val]
            tags$div(style=paste0("background-color:", bg, "; width:85px; border-radius:4px;"),
                     selectInput(ns(well), NULL, choices=names(renkler), selected=val))
          })
        })
      }
    })
    
    observe({
      for (w in wells) {
        observeEvent(input[[w]], {
          df$data$group[df$data$well == w] <- input[[w]]
        }, ignoreInit=TRUE)
      }
    })
    
    observeEvent(input$all_none, { df$data$group <- "none" })
    observeEvent(input$all_control, { df$data$group <- "control" })
    observeEvent(input$all_replicate, { df$data$group <- "replicate" })
    
    return(df)
  })
}

# ---- SERVER ----
shinyServer(function(input, output, session) {
  user_name <- reactiveVal(NULL)
  
  login_logic(input, user_name, allowed_users)
  
  output$login_status <- renderText({
    req(user_name())
    paste("Giriş yapıldı:", user_name())
  })
  
  observeEvent(user_name(), {
    req(user_name())
    
    insertTab("ana_menu", tabPanel("Form",
                                   fluidPage(
                                     sidebarLayout(
                                       sidebarPanel(
                                         selectInput("meta_in_mtt_hour", "MTT Hour:", choices = c("24H", "48H", "72H")),
                                         numericInput("meta_in_mtt_num", "MTT Number?", value = 0, min = 0),
                                         dateInput("meta_in_date", "Date (dd-mm-yyyy):", format = "dd-mm-%Y"),
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
                                     ),
                                     actionButton("logout_btn", "Çıkış Yap", class = "btn btn-danger")
                                   )
    ), target = "Login", position = "after")
    
    insertTab("ana_menu", tabPanel("Condition", condition_grid_ui("cond1")), target = "Form", position = "after")
    updateTabsetPanel(session, "ana_menu", selected = "Form")
    removeTab("ana_menu", "Login")
  })
  
  condition_vals <- condition_grid_server("cond1")
  
  observeEvent(input$kaydet, {
    req(input$data_file)
    
    df <- tryCatch(read_excel(input$data_file$datapath), error = function(e) NULL)
    if (is.null(df)) {
      showNotification("Dosya okunamadı", type = "error")
      return()
    }
    
    user <- user_name()
    folder <- file.path("user_data", user)
    if (!dir.exists(folder)) dir.create(folder, recursive = TRUE)
    
    file_name <- paste0("MTT_", input$meta_in_mtt_num, "_", input$meta_in_mtt_hour, "_",
                        format(input$meta_in_date, "%Y-%m-%d"), ".csv")
    
    write.csv(df, file = file.path(folder, file_name), row.names = FALSE)
    write.csv(condition_vals$data, file = file.path(folder, paste0("condition_", input$meta_in_mtt_num, ".csv")), row.names = FALSE)
    
    kayit <- data.frame(
      isim = user,
      mtt_num = input$meta_in_mtt_num,
      mtt_hour = input$meta_in_mtt_hour,
      mtt_date = format(input$meta_in_date, "%Y-%m-%d"),
      file = file_name,
      stringsAsFactors = FALSE
    )
    
    file_kayit <- "mtt_kayitlari.csv"
    if (file.exists(file_kayit)) {
      write.table(kayit, file = file_kayit, sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE)
    } else {
      write.table(kayit, file = file_kayit, sep = ",", row.names = FALSE, col.names = TRUE)
    }
  })
  
  output$meta_out_isim <- renderText({ req(user_name()); paste("İsim:", user_name()) })
  output$meta_out_mtt_hour <- renderText({ req(input$meta_in_mtt_hour); paste("Saat:", input$meta_in_mtt_hour) })
  output$meta_out_mtt_num <- renderText({ req(input$meta_in_mtt_num); paste("Numara:", input$meta_in_mtt_num) })
  output$meta_out_date <- renderText({ req(input$meta_in_date); paste("Tarih:", format(input$meta_in_date, "%d-%m-%Y")) })
  
  output$meta_out_summary <- renderText({
    path <- "mtt_kayitlari.csv"
    if (!file.exists(path)) return("Henüz kayıt yok.")
    df <- read.csv(path, stringsAsFactors = FALSE)
    paste(apply(df, 1, function(row) {
      paste(row["isim"], "-", row["mtt_num"], "-", row["mtt_hour"], "-", row["mtt_date"])
    }), collapse = "\n")
  })
  
  output$data_preview <- renderTable({
    req(input$data_file)
    read_excel(input$data_file$datapath)
  })
  
  observeEvent(input$logout_btn, {
    removeTab("ana_menu", "Form")
    removeTab("ana_menu", "Condition")
    insertTab("ana_menu", tabPanel("Login",
                                   fluidPage(
                                     logout_css,
                                     titlePanel("Login"),
                                     sidebarLayout(
                                       sidebarPanel(login_ui("login1")),
                                       mainPanel(textOutput("login_status"))
                                     )
                                   )
    ), position = "before")
    user_name(NULL)
    updateTabsetPanel(session, "ana_menu", selected = "Login")
  })
})
