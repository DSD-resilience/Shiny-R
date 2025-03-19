# This is a Shiny web application that features a slider widget.
library(shiny)

# Define UI
ui <- fluidPage(
  
  # App title
  titlePanel("Simple Shiny App with a Widget"),
  
  # Sidebar layout with input and output
  sidebarLayout(
    
    # Sidebar with a slider input
    sidebarPanel(
      sliderInput("num", 
                  "Choose a number:", 
                  min = 1, 
                  max = 150, 
                  value = 50)
    ),
    
    # Main panel to display output
    mainPanel(
      textOutput("selected_number")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Display the selected number
  output$selected_number <- renderText({
    paste("You selected:", input$num)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
