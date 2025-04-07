# Install the shiny widgets package if not already installed:
install.packages("shinyWidgets")

library(shiny)
library(shinyWidgets)

ui <- fluidPage(
  titlePanel("HTML Toggle Switch Example"),
  
  switchInput(
    inputId = "my_switch",
    label = "Enable Site Inspections",   # Optional label
    onLabel = "Yes",
    offLabel = "No",
    value = TRUE
  ),
  
  verbatimTextOutput("switch_status")
)

server <- function(input, output, session) {
  output$switch_status <- renderPrint({
    paste("Switch is set to:", input$my_switch)
  })
}

shinyApp(ui, server)
