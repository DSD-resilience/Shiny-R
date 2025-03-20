# interactive checkbox demo
library(shiny)

ui <- fluidPage(
  titlePanel("Interactive Checkboxes and Radio Buttons"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("checkGroup", 
                         label = "Select fruit:", 
                         choices = list("Apple" = 1, 
                                        "Banana" = 2, 
                                        "Cherry" = 3),
                         selected = 1),
      radioButtons("radio", 
                   label = "Select background color:",
                   choices = list("Light Blue" = "lightblue", 
                                  "Light Green" = "lightgreen",
                                  "Light Yellow" = "lightyellow"),
                   selected = "lightblue")
    ),
    mainPanel(
      verbatimTextOutput("value"),
      div(style = paste0("background-color:", "lightblue"), 
          textOutput("colorText"),
          style = "padding: 20px; border: 1px solid black;")
    )
  )
)

server <- function(input, output) {
  output$value <- renderPrint({ 
    input$checkGroup 
  })
  
  output$colorText <- renderText({
    paste("The background color is:", input$radio)
  })
  
  observe({
    output$colorText <- renderText({
      paste("The background color is:", input$radio)
    })
    output$value <- renderPrint({ 
      input$checkGroup 
    })
    output$colorDiv <- renderUI({
      div(style = paste0("background-color:", input$radio),
          textOutput("colorText"),
          style = "padding: 20px; border: 1px solid black;")
      
    })
  })
  
  observeEvent(input$radio, {
    output$colorDiv <- renderUI({
      div(style = paste0("background-color:", input$radio),
          textOutput("colorText"),
          style = "padding: 20px; border: 1px solid black;")
    })
  })
  observeEvent(input$checkGroup, {
    output$value <- renderPrint({ 
      input$checkGroup 
    })
  })
  
  output$colorDiv <- renderUI({
    div(style = paste0("background-color:", input$radio),
        textOutput("colorText"),
        style = "padding: 20px; border: 1px solid black;")
  })
  
}

shinyApp(ui = ui, server = server)

