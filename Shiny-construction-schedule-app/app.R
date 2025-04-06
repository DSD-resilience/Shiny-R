# library(shiny)
library(timevis)
library(plotly)
library(dplyr)

# Sample inspection schedule
inspection_data <- data.frame(
  Task = c("Foundation Inspection", "Framing Check", "Electrical Review", "Final Walkthrough"),
  Start = as.Date(c("2025-04-08", "2025-04-15", "2025-04-22", "2025-05-01")),
  End = as.Date(c("2025-04-08", "2025-04-16", "2025-04-22", "2025-05-01"))
)

# Prepare data for timevis (timeline widget)
timevis_data <- inspection_data %>%
  mutate(id = row_number(), content = Task) %>%
  select(id, content, start = Start, end = End)

# Prepare data for Gantt chart
gantt_data <- inspection_data %>%
  mutate(
    Duration = as.numeric(End - Start),
    Task = factor(Task, levels = rev(Task))  # Reverse order for Gantt
  )

# UI
ui <- fluidPage(
  titlePanel("Construction Inspection Scheduler with Gantt Chart"),
  fluidRow(
    column(6,
           h3("Inspection Timeline"),
           timevisOutput("inspection_timeline")
    ),
    column(6,
           h3("Gantt Chart View"),
           plotlyOutput("gantt_chart")
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Render timeline
  output$inspection_timeline <- renderTimevis({
    timevis(timevis_data)
  })
  
  # Render Gantt chart
  output$gantt_chart <- renderPlotly({
    plot_ly(
      gantt_data,
      x = ~Start,
      xend = ~End,
      y = ~Task,
      yend = ~Task,
      type = 'scatter',
      mode = 'lines',
      line = list(width = 20),
      hoverinfo = 'text',
      text = ~paste("Task:", Task, "<br>Start:", Start, "<br>End:", End)
    ) %>%
      layout(
        xaxis = list(title = "Date"),
        yaxis = list(title = ""),
        title = "Gantt Chart of Inspections"
      )
  })
}

# Run the app
shinyApp(ui, server)
