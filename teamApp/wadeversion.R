library(shiny)
library(tidyverse)
library(readr)
library(bslib)
dataset <- read_csv("Data_S1.csv")
# other libraries here

# data loading and one-time processing here

# data loading and one-time processing here
Data_S1 <- Data_S1 |> mutate(bodymass_life_ratio = Bodymass/Longevity)
Data_S1 <- Data_S1 |> mutate(log10bodymass = log10(Bodymass))
my_breaks <- c(1,2,3,4,5,6,7,8)
bigger_breaks <- c(1,10,100,1000,10000,100000,1000000,10000000,100000000) 
options(scipen = 999)
# Define UI for application 
ui <- fluidPage( #create the overall page
  #UI code here
  
  sidebarPanel(
    radioButtons("Order", #the input variable that the value will go into
                 "Choose a order to display:",
                 c("Afrosoricida", "Artiodactyla", "Carnivora","Cetacea","Cingulata","Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","Pilosa","Prosimians","Pinnipeds","Rodentia","Yangochiroptera","Yinpterochiroptera")
                 
    )),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("histogram"),
    plotOutput("histogram2")
  )
)



# Define server logic 

server <- function(input, output) {
  output$histogram <- renderPlot({
    order <- Data_S1 |>
      filter(Order == input$Order)
    pl <- ggplot(order, aes(x=log10bodymass)) + labs(x = "log10 bodymass(g)")
    pl + geom_histogram(breaks = my_breaks, fill = "steelblue", color = "white")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
