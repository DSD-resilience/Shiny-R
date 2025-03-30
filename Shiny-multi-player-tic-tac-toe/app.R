library(shiny)

# This is the simplest mult-player game
# A common bug from more complex versions comes from reactiveValue() with no arguments inside
# Another common bug is not placing reactiveValue() inside the actual server logic

# UI
ui <- fluidPage(
  titlePanel("Simple Emoji Tic-Tac-Toe"),
  uiOutput("board"),
  actionButton("reset", "🔄 Reset Game")
)

# Server
server <- function(input, output, session) {
  game <- reactiveValues(
    board = matrix("", nrow = 3, ncol = 3),
    turn = "X"
  )
  
  # Map turn to emoji
  emoji <- function(player) {
    if (player == "X") return("❌")
    if (player == "O") return("🟢")
    return("")
  }
  
  # Reset board
  observeEvent(input$reset, {
    game$board <- matrix("", nrow = 3, ncol = 3)
    game$turn <- "X"
  })
  
  # Handle cell clicks
  observe({
    for (i in 1:3) {
      for (j in 1:3) {
        local({
          ii <- i; jj <- j
          btn_id <- paste0("cell_", ii, "_", jj)
          observeEvent(input[[btn_id]], {
            if (game$board[ii, jj] == "") {
              game$board[ii, jj] <- game$turn
              game$turn <- ifelse(game$turn == "X", "O", "X")
            }
          })
        })
      }
    }
  })
  
  # Render board UI
  output$board <- renderUI({
    tagList(
      lapply(1:3, function(i) {
        fluidRow(
          lapply(1:3, function(j) {
            btn_id <- paste0("cell_", i, "_", j)
            actionButton(
              inputId = btn_id,
              label = emoji(game$board[i, j]),
              style = "width: 60px; height: 60px; font-size: 30px; margin: 2px;"
            )
          })
        )
      })
    )
  })
}

# Run app
shinyApp(ui, server)



# This app allows anyone connected to the app to modify the shared board.

# In practice, you'd want to assign unique player IDs or names, and manage concurrency better.

# You can extend this with shinyjs, or make it a more advanced game using Firebase or `shiny.router`.
