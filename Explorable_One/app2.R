# Load the Shiny package
library(shiny)

# Define UI (User Interface)
ui <- fluidPage(
  
  # App title
  titlePanel("Iris Dataset Explorer"),
  
  # Sidebar with input controls
  sidebarLayout(
    sidebarPanel(
      # Dropdown menu to select X variable
      selectInput("xvar", "Select X-axis variable:", 
                  choices = names(iris)[1:4], 
                  selected = "Sepal.Length"),
      
      # Dropdown menu to select Y variable
      selectInput("yvar", "Select Y-axis variable:", 
                  choices = names(iris)[1:4], 
                  selected = "Sepal.Width"),
      
      # Checkbox to show/hide the regression line
      checkboxInput("show_lm", "Show Regression Line", FALSE)
    ),
    
    # Main panel to display output plot
    mainPanel(
      plotOutput("scatterPlot")
    )
  )
)

# Define Server logic
server <- function(input, output) {
  
  output$scatterPlot <- renderPlot({
    # Scatter plot of selected variables
    plot(iris[[input$xvar]], iris[[input$yvar]],
         xlab = input$xvar, ylab = input$yvar,
         col = as.factor(iris$Species), pch = 19, main = "Iris Scatter Plot")
    
    # Add regression line if checked
    if (input$show_lm) {
      model <- lm(iris[[input$yvar]] ~ iris[[input$xvar]])
      abline(model, col = "hotpink", lwd = 2)
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
