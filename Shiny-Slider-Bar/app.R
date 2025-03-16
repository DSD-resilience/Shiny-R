library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Simple Slider Example"),
  
  sidebarLayout(
    sidebarPanel(
      # Slider input: Select a number between 1 and 100
      sliderInput("slider", "Choose a value:", 
                  min = 1, max = 100, value = 50)
    ),
    
    mainPanel(
      # Display the selected value
      textOutput("selected_value")
    )
  )
)

# Define Server
server <- function(input, output) {
  output$selected_value <- renderText({
    paste("You selected:", input$slider)
  })
}

# Run the App
shinyApp(ui = ui, server = server)

# A slider input (sliderInput) lets the user select a value between 1 and 100.

# The selected value is displayed in real time using textOutput().

# The renderText() function updates the text dynamically whenever the slider moves.

# This is a simple and effective way to use a sliding bar (slider input) in Shiny! 