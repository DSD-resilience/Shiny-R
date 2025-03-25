# This is a Shiny web application for drop down menus.

library(shiny)

ui <- fluidPage(
  titlePanel("Distribution Selector Widget"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "dist",
        label = "Choose a distribution:",
        choices = c("Normal", "Uniform", "Exponential"),
        selected = "Normal"
      ),
      numericInput("n", "Number of observations:", value = 100, min = 10, max = 1000)
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    n <- input$n
    dist_data <- switch(input$dist,
                        "Normal" = rnorm(n),
                        "Uniform" = runif(n),
                        "Exponential" = rexp(n))
    
    hist(dist_data,
         main = paste("Histogram of", input$dist, "Distribution"),
         col = "#4682B4",
         border = "white")
  })
}

shinyApp(ui = ui, server = server)
