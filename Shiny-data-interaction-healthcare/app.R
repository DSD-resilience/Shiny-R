# library(shiny)
library(plotly)
library(DT)

# Sample Patient Data (replace with your actual data)
patient_data <- data.frame(
  PatientID = rep(1:10, each = 30),
  Date = rep(seq(as.Date("2023-01-01"), by = "day", length.out = 30), times = 10),
  VitalSign = sample(c("Heart Rate", "Blood Pressure", "Temperature"), 300, replace = TRUE),
  Value = rnorm(300, mean = 75, sd = 10),
  Diagnosis = sample(c("Diabetes", "Hypertension", "Asthma", NA), 300, replace = TRUE)
)

ui <- fluidPage(
  titlePanel("Patient Data Visualization"),
  sidebarLayout(
    sidebarPanel(
      selectInput("patient_id", "Select Patient ID:", choices = unique(patient_data$PatientID)),
      checkboxGroupInput("vital_signs", "Select Vital Signs:", choices = unique(patient_data$VitalSign), selected = unique(patient_data$VitalSign)),
      selectInput("diagnosis", "Filter by Diagnosis:", choices = c("All", unique(patient_data$Diagnosis)))
    ),
    mainPanel(
      plotlyOutput("timeSeriesPlot"),
      DTOutput("dataTable")
    )
  )
)

server <- function(input, output) {
  filtered_data <- reactive({
    data <- patient_data[patient_data$PatientID == input$patient_id & patient_data$VitalSign %in% input$vital_signs,]
    if (input$diagnosis != "All") {
      data <- data[data$Diagnosis == input$diagnosis,]
    }
    return(data)
  })
  
  output$timeSeriesPlot <- renderPlotly({
    plot_ly(filtered_data(), x = ~Date, y = ~Value, color = ~VitalSign, type = "scatter", mode = "lines+markers") %>%
      layout(title = paste("Patient ID:", input$patient_id, "Vital Signs Over Time"))
  })
  
  output$dataTable <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 5))
  })
}

shinyApp(ui = ui, server = server)

# time-series plot with filtering and drill-down capabilities
