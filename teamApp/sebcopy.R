library(shiny)
library(tidyverse)
library(readr)
library(bslib)
dataset <- read_csv("Data_S1.csv")
# other libraries here

# data loading and one-time processing here


# Define UI for application 
ui <- fluidPage( #create the overall page
    #UI code here
  sidebar(
    ui <- page_fixed(
    input_dark_mode(id = "mode"), 
    textOutput("mode"),
    sidebarPanel(
      radioButtons("order", #the input variable that the value will go into
                   "Choose a order to display:",
                   c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","")    
                   
      )))),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("histogram")
    )
)
# Define server logic 

#States Color Mode 
server <- function(input, output) {
  output$mode <- renderText({
    paste("You are in", input$mode, "mode.")
  })
  output$histogram <- renderPlot({
    order <- Data_S1 |>
      filter(ordering == input$Order)
    pl <- ggplot(order, aes(x=bodymass_life_ratio))
    pl + geom_histogram()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
