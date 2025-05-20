#
# This is a Shiny web application for a healthcare patient dashboard.
#
library(shiny)
library(ggplot2)
library(DT)
library(dplyr)

ui <- fluidPage(
  titlePanel("Healthcare Patient Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload Patient Data (CSV)", accept = ".csv"),
      uiOutput("var_select_ui"),
      sliderInput("age_range", "Filter by Age", min = 0, max = 100, value = c(20, 60)),
      selectInput("condition", "Condition", choices = c("All"), selected = "All")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Patient Table", DTOutput("patient_table")),
        tabPanel("Health Trend Plot", plotOutput("health_plot"))
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive data after file upload
  patient_data <- reactive({
    req(input$file)
    df <- read.csv(input$file$datapath)
    df
  })
  
  # Dynamically generate variable choices after upload
  output$var_select_ui <- renderUI({
    req(patient_data())
    selectInput("metric", "Select Health Metric", choices = names(patient_data())[sapply(patient_data(), is.numeric)])
  })
  
  # Update condition choices dynamically
  observe({
    df <- patient_data()
    updateSelectInput(session, "condition", choices = c("All", unique(df$Condition)))
  })
  
  # Filtered data based on inputs
  filtered_data <- reactive({
    df <- patient_data()
    df <- df %>% filter(Age >= input$age_range[1], Age <= input$age_range[2])
    if (input$condition != "All") {
      df <- df %>% filter(Condition == input$condition)
    }
    df
  })
  
  # Render patient table
  output$patient_table <- renderDT({
    datatable(filtered_data())
  })
  
  # Render health metric plot
  output$health_plot <- renderPlot({
    req(input$metric)
    df <- filtered_data()
    ggplot(df, aes_string(x = "Date", y = input$metric, color = "PatientID")) +
      geom_line() +
      labs(title = paste("Health Metric:", input$metric), y = input$metric) +
      theme_minimal()
  })
}

shinyApp(ui, server)
