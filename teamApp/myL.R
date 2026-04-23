library(shiny)
library(tidyverse)
library(readr)
dataset <- read_csv("Data_S1.csv")
# other libraries here

# data loading and one-time processing here


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


#example


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
                   c("Cetacea", "Adrosoricida", "Artidodactyla","Carnivora",'Cingulata',"Eulipotyphla","Lagomorpha","New_World_monkeys","Old_World_monkeys","Perissodactyla","")
      )),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("violin_plot")
    )
  )
)


# Define server logic required to draw a box. plot
server <- function(input, output) {
  
  # Expression that generates a boxplot. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$violin_plot <- renderPlot({
    
    iris_species <- iris %>%
      filter(Species == input$species)
    
    iris_long <- iris_species %>%
      pivot_longer(
        cols = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
        names_to = "Trait",
        values_to = "Value"
      )
    
    # set up the plot
    pl <- ggplot(iris_long, aes(x = Trait, y = Value, fill = Trait)) +
      geom_violin(trim = FALSE)
    
    # draw the boxplot for the specified trait
    pl + geom_violin()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
