library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Choose Your Mood (Image Selector)"),
  
  tags$style(HTML("
    .img-option {
      cursor: pointer;
      border: 4px solid transparent;
      border-radius: 8px;
      transition: border 0.3s;
      height: 100px;
    }
    .img-option:hover {
      border: 4px solid #007bff;
    }
    .selected-img {
      border: 4px solid #28a745 !important;
    }
  ")),
  
  uiOutput("imageButtons"),
  verbatimTextOutput("selectedMood")
)

# Define server logic
server <- function(input, output, session) {
  moods <- c("Happy", "Sad", "Angry")
  images <- c("https://i.imgur.com/JZ3HL9C.png",  # Happy face
              "https://i.imgur.com/RzNRmUh.png",  # Sad face
              "https://i.imgur.com/J4T8m1c.png")  # Angry face
  
  output$imageButtons <- renderUI({
    tags$div(
      style = "display: flex; gap: 20px;",
      lapply(seq_along(moods), function(i) {
        tags$label(
          class = ifelse(input$mood == moods[i], "selected-img", ""),
          tags$input(
            type = "radio",
            name = "mood",
            value = moods[i],
            checked = if (i == 1) TRUE else FALSE,
            onchange = sprintf("Shiny.setInputValue('mood', '%s', {priority: 'event'})", moods[i]),
            style = "display: none;"
          ),
          tags$img(src = images[i], class = "img-option")
        )
      })
    )
  })
  
  output$selectedMood <- renderText({
    paste("You selected mood:", input$mood)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
