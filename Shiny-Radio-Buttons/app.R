library(shiny)

# Define UI for application 
ui <- fluidPage(
  tags$h1("Radio Buttons with Matching Label and Color Preview", style = "font-weight: bold;"),
  
  sidebarLayout(
    sidebarPanel(
      # Radio buttons with labels as names and color values as values
      radioButtons("color", "Choose a color:",
                   choices = c("Red" = "Red", "Blue" = "Blue", "Green" = "Green"),
                   selected = "Red")  # Default selection
    ),
    
    mainPanel(
      # Output UI for selected color name and color preview
      uiOutput("color_display")
    )
  )
)

# Define server logic required 

server <- function(input, output) {
  output$color_display <- renderUI({
    div(
      "You selected:", strong(input$color),  # Shows the selected label, not value
      div(
        style = paste("display: inline-block; width: 50px; height: 20px; 
                               margin-left: 10px; background-color:", tolower(input$color), ";")
      )
    )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

# radioButtons() creates a set of radio buttons with three color choices.

# The input ID is "color", meaning the selected value is accessible as input$color in the server.

# The renderText() function updates the text output whenever the user selects a new option.