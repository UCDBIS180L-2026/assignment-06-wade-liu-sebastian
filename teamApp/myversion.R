library(shiny)
library(tidyverse)
library(readr)
dataset <- read_csv("Data_S1.csv")
# other libraries here

# data loading and one-time processing here
Data_S1 <- Data_S1 |> mutate(bodymass_life_ratio = Bodymass/Longevity)




# Define server logic 
server <- function(input, output) {
  output$histogram <- renderPlot({
    order <- Data_S1 |>
      filter(ordering == input$Order)
    pl <- ggplot(order, aes(x=bodymass_life_ratio))
    pl + geom_histogram()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
