# this is from Chapter One of "Mastering Shiny" by Wickham
library(shiny)

# Define UI
ui <- fluidPage(
  
  # App Title
  titlePanel("Personalized Greeting App"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      textInput("name", "What's your name?"),  # User enters their name
      numericInput("age", "How old are you?", value = NA)  # User enters their age
    ),
    
    mainPanel(
      textOutput("greeting"),   # Displays the personalized greeting
      plotOutput("histogram"),  # Displays a histogram plot
      tableOutput("mortgage")   # Placeholder for a potential mortgage table
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  # Generate the greeting message
  output$greeting <- renderText({
    req(input$name)  # Ensure input is not empty
    paste0("Hello ", input$name, "!")
  })
  
  # Render a histogram
  output$histogram <- renderPlot({
    hist(rnorm(1000), main = "Random Normal Distribution", col = "blue", border = "white")
  }, res = 96)
  
  # Placeholder for a mortgage table (if needed in the future)
  output$mortgage <- renderTable({
    data.frame(ExampleColumn = c("Data will go here"))
  })
}

# Run the App
shinyApp(ui, server)

