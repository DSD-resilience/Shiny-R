# This is a simple example of how to add interactivity to your plot using plotly.
library(plotly)

output$plot <- renderPlotly({
  plot_ly(data = mtcars, x = ~mpg, y = ~hp, type = 'scatter', mode = 'markers')
})

# These types of widgets are usually added inside a UI output function like:
# plotlyOutput(), leafletOutput(), dygraphOutput(), or DTOutput()
# and then rendered in the server side with the corresponding render*() function.

