# modules.R

# ---- LOGIN UI ----
login_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("name"), "İsminizi girin:"),
    actionButton(ns("login_btn"), "Giriş Yap"),
    textOutput(ns("status"))
  )
}

# ---- LOGIN LOGIC ----
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
