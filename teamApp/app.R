# Loading main libraries 
library(shiny)
library(tidyverse)
library(readr)
library(bslib)
library(thematic)
library(janitor)

# data loading and one-time processing here
Data_S1 <- read_csv("Data_S1.csv")
avg_life <- mean(Data_S1$Longevity) #compute avg lifespan
Data_S1 <- Data_S1 |> mutate(bodymass_life_ratio = (Bodymass/Longevity)*avg_life) #get ratio of body mass to longevity scaled by the avg life so that the graphs can be meaningfully compared
Data_S1 <- Data_S1 |> mutate(log10bodymass_life_ratio = log10(bodymass_life_ratio)) #take log of this so that it can be viewed easily on graph
Data_S1 <- Data_S1 |> mutate(log10bodymass = log10(Bodymass)) #so that it can be viewed easily on graph
my_breaks <- c(0,1,2,3,4,5,6) #custom breaks so that each graph is the same and can be compared to each other. default values would make this impossible
bigger_breaks <- c(1,10,100,1000,10000,100000)#same as above
options(scipen = 999) # so that any numbers will not be displayed in scientific notation
thematic_shiny()

# Define UI for application 
ui <- navbarPage(
#Loads the UI for light/dark mode switcher. flatly is the default dark theme. 
  theme = bs_theme(bootswatch = "flatly"),
  nav_spacer(),
  nav_item(input_dark_mode(id = "theme_toggle")), 
#This puts the panel for the histrogram into the UI, inside the navigation bar at the top. 
  tabPanel("Histogram",
    sidebarLayout(
      sidebarPanel(
# Provides the options for each of the graphs for both histograms.
        radioButtons("Order_histogram", #the input variable that the value will go into
                 "Choose a order to display:",
                 c("Afrosoricida", "Artiodactyla", "Carnivora","Cetacea","Cingulata","Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","Pilosa","Prosimians","Pinnipeds","Rodentia","Yangochiroptera","Yinpterochiroptera")    
    )),
# These plot the two histogram outputs.
      mainPanel(
        plotOutput("histogram"),
        plotOutput("histogram2")
      )
    )
  ),
# This load the tab panel for the Order plot 
  tabPanel("Body Mass and Longevity by Order",
    sidebarLayout(
      sidebarPanel(
# Creates a dropdown menu to select the order
        selectInput("Order_plot", #the input variable that the value will go into
                  "Choose a order to display:",
                  c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla")    
    )),
# Plots the species plot 
    mainPanel(
      plotOutput("species_plot")
      )
    )
  ),
# Creates About Panel and loads a markdown file describing it. 
  tabPanel("About",
    fluidRow(
      column(8, offset = 2, 
        includeMarkdown("About.md")
      )
    )
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
      filter(Order == input$Order_histogram)
    thematic_shiny()
    pl <- ggplot(order, aes(x=log10bodymass)) + labs(x = "log10 bodymass(g)")
    pl + geom_histogram(breaks = my_breaks, fill = "steelblue", color = "white")
  })
  
  #this bottom graph represents each species bodymass rescaled by how long it lives compared to an average species lifespan
  output$histogram2 <- renderPlot({
    order <- Data_S1 |>
      filter(Order == input$Order_histogram)
    thematic_shiny()
    pl <- ggplot(order, aes(x=log10bodymass_life_ratio))+ labs(x = "(log10 bodymass(g)/lifespan (yrs))*(avg lifespan (yrs))")
    pl + geom_histogram(breaks = my_breaks, fill = "coral2", color = "white")
  })
#Explanation of the above chunk: If the graphs are roughly identical, that means that body mass and longevity have scaled proportionately. If the re-scaled graph is shifted to the right, then the species in that order generally live shorter than expected for their bodymass. If it is shifted to the left, than the species in that order live longer than is expected for their bodymass. If re-scaled graph is more spread out it could suggest that longevity varies independently of body mass.

  output$species_plot <- renderPlot({
    order_data <- Data_S1 %>%
      filter(Order == input$Order_plot)
    thematic_shiny()
    ggplot(order_data, aes(x = Bodymass, y = Longevity)) +
      geom_point() +
      geom_text(aes(label = Species), size = 2) +
      scale_x_log10() +
      labs(
        x = "Body Mass",
        y = "Longevity"
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
