# This app allows the user to choose the color of the histogram

library(shiny)

ui <- fluidPage(
  titlePanel("Histogram Color Example"),
  sidebarLayout(
    sidebarPanel(
      selectInput("color", "Choose a color:", 
                  choices = c("red", "blue", "green", "orange", "purple"))
    ),
    mainPanel(
      plotOutput("histPlot")
    )
  )
)

server <- function(input, output) {
  output$histPlot <- renderPlot({
    hist(rnorm(100), col = input$color, main = "Histogram with Custom Color")
  })
}

shinyApp(ui = ui, server = server)

