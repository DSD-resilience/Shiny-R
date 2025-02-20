# This is a Shiny web application. 

install.packages(c("shiny", "wordcloud2", "tm", "readr", "colourpicker"))

library(shiny)
library(wordcloud2)
library(tm)
library(readr)
library(colourpicker)

# UI ----
ui <- fluidPage(
  titlePanel("Interactive Word Cloud"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput("text_input", "Enter text manually:", 
                    placeholder = "Type or paste text here...", rows = 5),
      fileInput("file_input", "Upload a CSV file:", 
                accept = c(".csv")),
      numericInput("num_words", "Number of words:", 100, min = 5),
      colourInput("bg_color", "Background color:", value = "white"),
      actionButton("generate", "Generate Word Cloud")
    ),
    mainPanel(
      wordcloud2Output("cloud")
    )
  )
)

# Server ----
server <- function(input, output, session) {
  
  # Reactive expression to process text input
  processed_text <- reactive({
    req(input$generate)  # Ensure action button is clicked
    
    text_data <- ""
    
    # Use text input if available
    if (nzchar(input$text_input)) {
      text_data <- input$text_input
    } 
    # Use uploaded file if available
    else if (!is.null(input$file_input)) {
      df <- read_csv(input$file_input$datapath, col_names = FALSE)
      text_data <- paste(df[[1]], collapse = " ")
    }
    
    # Convert text to corpus
    corpus <- Corpus(VectorSource(text_data))
    corpus <- tm_map(corpus, content_transformer(tolower))
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, removeNumbers)
    corpus <- tm_map(corpus, removeWords, stopwords("en"))
    
    # Create Term Document Matrix
    tdm <- TermDocumentMatrix(corpus)
    matrix <- as.matrix(tdm)
    word_freq <- sort(rowSums(matrix), decreasing = TRUE)
    data.frame(word = names(word_freq), freq = word_freq)
  })
  
  # Render word cloud, the glorious word cloud
  output$cloud <- renderWordcloud2({
    req(processed_text())  # Ensure data is available
    wordcloud2(processed_text()[1:input$num_words, ], backgroundColor = input$bg_color)
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)

