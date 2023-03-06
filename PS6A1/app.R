

library(shiny)
library(tidyverse)
library(ggplot2)
setwd("/Users/thaliafelice/Desktop/ps6/PS6A1")
bikes <- read_csv("bikes.csv")

ui <- fluidPage(
    titlePanel("PS6 Assignment"),
    sidebarLayout(
      sidebarPanel(
        sliderInput("month",
                    "month of the year", 
                    value = 6,
                    min = 1,
                    max = 12),
        fluidRow(
          column(6,
                 radioButtons("color", "Choose Graphing Color", 
                              choices = c("thistle", "aquamarine","brown",
                                          "maroon", "blue", "orange"))),
        )),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Summary",mainPanel(
                    p("This is a summary paragraph")
                    )),
                    tabPanel("Plot", plotOutput("plot")),
                    tabPanel("Table", mainPanel("table"))
              )        
            )      
        )
      )
 
server <- function(input, output) {
  bikemonth <- reactive({
    bikes %>% 
      filter(month %in% input$month)
  })
  
  output$plot <- renderPlot({ # plot code goes here
    bikemonth() %>% 
      ggplot()+
      geom_line(aes(num_bikes_rented, solar_radiation,col=input$color))
  })
}  

shinyApp(ui = ui, server = server)



