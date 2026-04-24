library(shiny)
library(tidyverse)
library(readr)
library(bslib)
library(thematic)
library(janitor)
data <- read_csv("Data_S1.csv")%>% clean_names()
# other libraries here

thematic_shiny()
# data loading and one-time processing here

# data loading and one-time processing here
Data_S1 <- Data_S1 |> mutate(bodymass_life_ratio = Bodymass/Longevity)


# Define UI for application 
ui <- navbarPage(
  theme = bs_theme(bootswatch = "flatly"),
  nav_spacer(),
  nav_item(input_dark_mode(id = "theme_toggle")), 
  tabPanel("Histogram",
    sidebarLayout(
      sidebarPanel(
        radioButtons("Order", #the input variable that the value will go into
                 "Choose a order to display:",
                 c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","")    
    )),
      mainPanel(
        plotOutput("histogram")))),
  tabPanel("Plot",
    sidebarLayout(
      sidebarPanel(
        selectInput("Order", #the input variable that the value will go into
                  "Choose a order to display:",
                  c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla")    
    )),
    mainPanel(
      plotOutput("species_plot")),
  
  tabPanel("About"),
    fluidRow(
      
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
      filter(Order == input$Order)
    thematic_shiny()
    pl <- ggplot(order, aes(x=bodymass_life_ratio))
    pl + geom_histogram()
  }) 
  output$species_plot <- renderPlot({
    order_data <- Data_S1 %>%
      filter(Order == input$Order)
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
