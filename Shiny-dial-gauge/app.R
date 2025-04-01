# A 'dial' using current pre-made code tends to be gauge.

library(shiny)
library(flexdashboard)  # for gauge()

ui <- fluidPage(
  titlePanel("Dial Gauge Example"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("value", "Set Gauge Value:", min = 0, max = 100, value = 50)
    ),
    mainPanel(
      gaugeOutput("gauge_plot")
    )
  )
)

server <- function(input, output, session) {
  output$gauge_plot <- renderGauge({
    gauge(input$value, min = 0, max = 100, symbol = '%', 
          sectors = gaugeSectors(success = c(80, 100), warning = c(50, 79), danger = c(0, 49)))
  })
}

shinyApp(ui, server)

# gauge() creates a semicircular dial with customizable color zones (success, warning, danger).

# You can dynamically update the gauge using reactive inputs like a slider, numeric input, or data from a backend process.

# It works best with numeric values that fit naturally within a min-max range.

# More custom looks can be acheived with: 

# plotly::plot_ly() with polar coordinates

# echarts4r with its built-in gauge chart

# highcharter::highchart(type = "gauge") for rich dial options
