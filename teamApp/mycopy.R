library(shiny)
library(tidyverse)
library(readr)
dataset <- read_csv("Data_S1.csv")
# other libraries here

# data loading and one-time processing here


# Define UI for application 
ui <- fluidPage( #create the overall page
    #UI code here
  )


# Define server logic 
server <- function(input, output) {
  # server code here
}

# Run the application 
shinyApp(ui = ui, server = server)
