# This is a clear and relatable way to communicate levels of completion, etc.
library(shiny)
library(flexdashboard)  # for the gauge function

ui <- fluidPage(
  titlePanel("Fuel Gauge Example"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("fuel", "Fuel Level (%)", min = 0, max = 100, value = 50)
    ),
    mainPanel(
      gaugeOutput("fuelGauge")
    )
  )
)

server <- function(input, output, session) {
  output$fuelGauge <- renderGauge({
    gauge(
      value = input$fuel,
      min = 0,
      max = 100,
      symbol = '%',
      label = "Fuel Level",
      sectors = gaugeSectors(
        success = c(60, 100),
        warning = c(30, 60),
        danger = c(0, 30)
      )
    )
  })
}

shinyApp(ui, server)
