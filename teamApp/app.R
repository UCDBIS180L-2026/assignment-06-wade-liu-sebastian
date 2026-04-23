library(shiny)
library(tidyverse)
library(readr)
dataset <- read_csv("Data_S1.csv")
# other libraries here

# data loading and one-time processing here
ui <- fluidPage( 
  titlePanel("Eutherian Mammals"),
  
  helpText("This application creates a violin plot to show difference between",
           "iris species.  Please use the radio box below to choose a trait",
           "for plotting"),
  
  # Sidebar with a radio box to input which trait will be plotted
  sidebarLayout(
    sidebarPanel(
      radioButtons("order", #the input variable that the value will go into
                   "Choose a order to display:",
                   c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","Pilosa","Pinnipeds","Prosimians","Rodentia","Yangochiroptera","Yinpterochiroptera")
      )),

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
