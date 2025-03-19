library(shiny)
library(DT)

# Sample data
data <- data.frame(
  Name = c("Alice", "Bob", "Charlie", "David", "Eve"),
  Age = c(25, 30, 28, 35, 22),
  City = c("New York", "London", "Tokyo", "Paris", "Sydney"),
  Score = c(85, 92, 78, 95, 88)
)

ui <- fluidPage(
  titlePanel("Interactive Data Table"),
  DTOutput("dataTable")
)

server <- function(input, output) {
  output$dataTable <- renderDT({
    datatable(data,
              options = list(
                pageLength = 5,
                searching = TRUE,
                ordering = TRUE,
                paging = TRUE
              ),
              selection = 'multiple', # Allows multiple row selection
              rownames = FALSE # Removes row numbers
    )
  })
}

shinyApp(ui = ui, server = server)


