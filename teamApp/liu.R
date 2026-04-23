library("tidyverse")
library("naniar")
library("janitor")
library("ggthemes")
library("RColorBrewer")
library("paletteer")
library("ggplot2")
library("shiny")
library("readr")

data <- read_csv("Data_S1.csv")%>% clean_names()


ui <- fluidPage(
  titlePanel("Body Mass and Longevity by Order"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "order",
        "Choose a order:",
        choices = c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","Pilosa","Pinnipeds","Prosimians","Rodentia","Yangochiroptera","Yinpterochiroptera")
      )
    ),
    
    mainPanel(
      plotOutput("species_plot")
    )
  )
)

server <- function(input, output) {
  
  output$species_plot <- renderPlot({
    
    order_data <- data %>%
      filter(order==input$order)
    
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

shinyApp(ui = ui, server = server)