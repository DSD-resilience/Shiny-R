library(shiny)
library(visNetwork)

# Define UI
ui <- fluidPage(
  titlePanel("Simple Network Graph in Shiny"),
  visNetworkOutput("network_plot")  # Output for the network graph
)

# Define Server
server <- function(input, output) {
  output$network_plot <- renderVisNetwork({
    
    # Define Nodes
    nodes <- data.frame(id = 1:5, 
                        label = c("A", "B", "C", "D", "E"),
                        color = c("red", "blue", "green", "orange", "purple"))
    
    # Define Edges (Connections)
    edges <- data.frame(from = c(1, 1, 2, 3, 4), 
                        to = c(2, 3, 4, 5, 5))
    
    # Create Interactive Network Graph
    visNetwork(nodes, edges) %>%
      visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
