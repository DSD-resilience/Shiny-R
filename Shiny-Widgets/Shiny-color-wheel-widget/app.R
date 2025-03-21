# Try a color wheel instead of a slider input
library(shiny)

ui <- fluidPage(
  titlePanel("Interactive Color Wheel"),
  sidebarLayout(
    sidebarPanel(
      actionButton("randomize", "Randomize Colors"),
      br(),
      br(),
      tags$div(
        style = "position: relative; width: 200px; height: 200px; border-radius: 50%; background: linear-gradient(to right, red, yellow, green, cyan, blue, magenta, red);",
        tags$div(
          id = "colorPicker",
          style = "position: absolute; width: 20px; height: 20px; border-radius: 50%; background-color: white; top: 90px; left: 90px; cursor: crosshair;"
        )
      ),
      br(),
      textOutput("selectedColor")
    ),
    mainPanel(
      plotOutput("colorPlot")
    )
  )
)

server <- function(input, output, session) {
  
  color_values <- reactiveVal(c(100, 100)) # Initial position
  
  observeEvent(input$randomize, {
    color_values(c(sample(0:180, 1), sample(0:180, 1)))
  })
  
  observeEvent(input$colorPicker_drag, {
    if (!is.null(input$colorPicker_drag)) {
      x <- as.numeric(input$colorPicker_drag$x)
      y <- as.numeric(input$colorPicker_drag$y)
      
      # Center the coordinate system
      x_centered <- x - 100
      y_centered <- y - 100
      
      # Limit movement within the circle
      if (sqrt(x_centered^2 + y_centered^2) <= 90) {
        color_values(c(x, y))
      }
    }
  })
  
  output$colorPlot <- renderPlot({
    x <- color_values()[1]
    y <- color_values()[2]
    
    # Center the coordinate system
    x_centered <- x - 100
    y_centered <- y - 100
    
    # Calculate angle and radius
    angle <- atan2(y_centered, x_centered) * 180 / pi
    if (angle < 0) {
      angle <- angle + 360
    }
    radius <- sqrt(x_centered^2 + y_centered^2)
    
    # Calculate color based on angle and radius
    hsv_color <- hsv(angle / 360, radius / 90, 1)
    
    output$selectedColor <- renderText({
      paste("Selected Color:", hsv_color)
    })
    
    plot(0, 0, type = "n", xlim = c(-1, 1), ylim = c(-1, 1), xlab = "", ylab = "", axes = FALSE)
    symbols(0, 0, circles = 1, inches = FALSE, add = TRUE, fg = "black", bg = hsv_color)
  })
  
  observe({
    x <- color_values()[1]
    y <- color_values()[2]
    session$sendCustomMessage(type = "updatePicker",
                              message = list(x = x, y = y))
  })
  
  session$onSessionEnded(function() {
    session$sendCustomMessage(type = "removeDrag", message = list())
  })
  
  session$onFlushed(function() {
    session$sendCustomMessage(type = "addDrag", message = list())
  })
}

shinyApp(ui, server)

