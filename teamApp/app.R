library(shiny)
library(tidyverse)
library(readr)
library(bslib)
library(thematic)
dataset <- read_csv("Data_S1.csv")
# other libraries here

thematic_shiny()
# data loading and one-time processing here

# data loading and one-time processing here
Data_S1 <- Data_S1 |> mutate(bodymass_life_ratio = Bodymass/Longevity)


# Define UI for application 
ui <- page_navbar(
  theme = bs_theme(bootswatch = "flatly"),
  nav_spacer(),
  nav_item(input_dark_mode(id = "theme_toggle")), # 
  nav_panel(
    radioButtons("Order", #the input variable that the value will go into
                 "Choose a order to display:",
                 c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","")    
    ),
    card(plotOutput("histogram")),
    title = "Navigation",
  nav_panel(
    selectInput("Order", #the input variable that the value will go into
                 "Choose a order to display:",
                 c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","")    
    ),
    card(plotOutput("species_plot")),
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
    
    order_data <- data %>%
      filter(order == input$order)
    
    ggplot(order_data, aes(x = bodymass, y = longevity)) +
      geom_point() +
      geom_text(aes(label = species), size = 2) +
      scale_x_log10() +
      theme_minimal() +
      labs(
        x = "Body Mass",
        y = "Longevity"
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
