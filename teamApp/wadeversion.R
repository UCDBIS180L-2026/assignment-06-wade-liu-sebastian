library(shiny)
library(tidyverse)
library(readr)
library(bslib)
library(readr)
Data_S1 <- read_csv("Data_S1.csv")
# other libraries here

# data loading and one-time processing here

# data loading and one-time processing here
avg_life <- mean(Data_S1$Longevity) #compute avg lifespan
Data_S1 <- Data_S1 |> mutate(bodymass_life_ratio = (Bodymass/Longevity)*avg_life) #get ratio of body mass to longevity scaled by the avg life so that the graphs can be meaningfully compared
Data_S1 <- Data_S1 |> mutate(log10bodymass_life_ratio = log10(bodymass_life_ratio)) #take log of this so that it can be viewed easily on graph
Data_S1 <- Data_S1 |> mutate(log10bodymass = log10(Bodymass)) #so that it can be viewed easily on graph
my_breaks <- c(0,1,2,3,4,5,6) #custom breaks so that each graph is the same and can be compared to each other. default values would make this impossible
bigger_breaks <- c(1,10,100,1000,10000,100000)#same as above
options(scipen = 999) # so that any numbers will not be displayed in scientific notation
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

#this top graph represents a histogram of bodymass log scale
server <- function(input, output) {
  output$histogram <- renderPlot({
    order <- Data_S1 |>
      filter(Order == input$Order)
    pl <- ggplot(order, aes(x=log10bodymass)) + labs(x = "log10 bodymass(g)")
    pl + geom_histogram(breaks = my_breaks, fill = "steelblue", color = "white")
  })

#this bottom graph represents each species bodymass rescaled by how long it lives compared to an average species lifespan
  output$histogram2 <- renderPlot({
    order <- Data_S1 |>
      filter(Order == input$Order)
    pl <- ggplot(order, aes(x=log10bodymass_life_ratio))+ labs(x = "(log10 bodymass(g)/lifespan (yrs))*(avg lifespan (yrs))")
    pl + geom_histogram(breaks = my_breaks, fill = "coral2", color = "white")
  })
}
#Explanation of the above chunk: If the graphs are roughly identical, that means that body mass and longevity have scaled proportionately. If the re-scaled graph is shifted to the right, then the species in that order generally live shorter than expected for their bodymass. If it is shifted to the left, than the species in that order live longer than is expected for their bodymass. If re-scaled graph is more spread out it could suggest that longevity varies independently of body mass.

# Run the application 
shinyApp(ui = ui, server = server)
