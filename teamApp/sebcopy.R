library(shiny)
library(tidyverse)
library(readr)
library(bslib)
library(thematic)
library(janitor)
Data_S1 <- read_csv("Data_S1.csv")%>% clean_names()
# other libraries here

thematic_shiny(font = "auto")
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
    title = "Navigation"
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
}

# Run the application 
shinyApp(ui = ui, server = server)
