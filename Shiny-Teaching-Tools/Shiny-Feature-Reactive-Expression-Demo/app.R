# This app demos using reactive expressions through a drop down menu that can filter 
# the data set by number of cylinders.
library(shiny)
library(dplyr)

ui <- fluidPage(
  titlePanel("Reactive Expression Demo"),
  sidebarLayout(
    sidebarPanel(
      selectInput("cyl", "Select Cylinder Count:",
                  choices = unique(mtcars$cyl),
                  selected = 4)
    ),
    mainPanel(
      tableOutput("filteredTable"),
      verbatimTextOutput("summaryStats")
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive expression to filter the mtcars dataset
  filtered_data <- reactive({
    mtcars %>% filter(cyl == input$cyl)
  })
  
  # Output the filtered table
  output$filteredTable <- renderTable({
    filtered_data()
  })
  
  # Output some summary statistics
  output$summaryStats <- renderPrint({
    summary(filtered_data())
  })
}

shinyApp(ui, server)
