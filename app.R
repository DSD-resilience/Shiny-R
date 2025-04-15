# This is a Shiny web application for displaying a patient's health information data.
# You can split it out to a UI file and Server file as needed.

library(shiny)

ui <- fluidPage(
  titlePanel("Health Information Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("ageRange", "Select Age Range:",
                  min = 18, max = 90, value = c(30, 60)),
      
      selectInput("gender", "Select Gender:",
                  choices = c("All", "Male", "Female"), selected = "All"),
      
      selectInput("metric", "Select Health Metric:",
                  choices = c("BMI", "Blood Pressure", "Cholesterol")),
      
      actionButton("apply", "Apply Filters")
    ),
    
    mainPanel(
      plotOutput("metricPlot"),
      tableOutput("summaryTable")
    )
  )
)


library(dplyr)
library(ggplot2)

# Example health dataset
set.seed(123)
health_data <- data.frame(
  Age = sample(18:90, 500, replace = TRUE),
  Gender = sample(c("Male", "Female"), 500, replace = TRUE),
  BMI = rnorm(500, 25, 5),
  `Blood Pressure` = rnorm(500, 120, 15),
  Cholesterol = rnorm(500, 200, 30)
)

server <- function(input, output) {
  
  filtered_data <- eventReactive(input$apply, {
    data <- health_data %>%
      filter(Age >= input$ageRange[1], Age <= input$ageRange[2])
    
    if (input$gender != "All") {
      data <- data %>% filter(Gender == input$gender)
    }
    return(data)
  })
  
  output$metricPlot <- renderPlot({
    req(filtered_data())
    ggplot(filtered_data(), aes_string(x = input$metric)) +
      geom_histogram(bins = 30) +
      labs(title = paste("Distribution of", input$metric))
  })
  
  output$summaryTable <- renderTable({
    req(filtered_data())
    data <- filtered_data()
    metric <- input$metric
    summary_stats <- data %>%
      summarise(
        Mean = mean(.data[[metric]]),
        Median = median(.data[[metric]]),
        SD = sd(.data[[metric]])
      )
    summary_stats
  })
}

shinyApp(ui = ui, server = server)

