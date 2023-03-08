

library(shiny)
library(tidyverse)
library(ggplot2)
bikes <- read_csv("bikes2.csv")

ui <- fluidPage(
    titlePanel("PS6 Assignment"),
    sidebarLayout(
      sidebarPanel(
       
        sliderInput("month",
                    "Select Month of the Year", 
                    value = 6,
                    min = 1,
                    max = 12),
        
        sliderInput("column", "Select Column Number in the Table",
                    value = 3,
                    min = 2,
                    max = 7),
                    
        
        fluidRow(
          column(4,
                 radioButtons("color", "Choose one to Select Graphing Color", 
                              choices = c("maroon", "brown",
                                          "blue", "orange"))),
        
        ),
                                          
          
        h3("Month Number Key"),
        p(strong(1), "- January"),
        p(strong(2), "- February"),
        p(strong(3), "- March"),
        p(strong(4), "- April"),
        p(strong(5), "- May"),
        p(strong(6), "- June"),
        p(strong(7), "- July"),
        p(strong(8), "- August"),
        p(strong(9), "- September"),
        p(strong(10), "- October"), 
        p(strong(11), "- November"),
        p(strong(12), "- December"),    
        
                                  
          
      ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
        tabPanel("Summary",mainPanel(
          h1("How Does Solar Radiation Affect Bike Rentals on a Given Day?"),
          h2("Overview"),
          p("My dataset comes from UCI Machine Learning Repository and it is what I will be using for the final group project. The data is from Seoul, South Korea
          and was collected from January 2017 to November 2018. Specifically, 
          I'm interested in what affect solar radiation (or in other words the presenceo of the sun or a 'nice day') may increase or decrease
          bike rentals. Before I started analyzing the data, my hypothesis was that higher amounts of solar radiation would lead to higher numbers of bike rentals, 
          because people would want to bike to enjoy a sunny day. However, I began to see something different."),
          h2("Findings"),
          p("In comparing the amount of solar radiation to bike rentals I found very little to no correlation. No graph for any month showed enough clustering or grouping 
            of the data points to suggest that there was a strong relationship between the two. One interesting characteristic I did see in the graphs was that the range of bike rentals between months
            increased from month 1 until month 7. After month 7, the range began to decrease each month."),
          h2("Conclusion"),
          p("Though I hypothesized a positive relationship between solar radiation and bike rentals, the data disproves this hypothesis. There is no correlation between the variables."),
          tableOutput("full")
          )),
          
        tabPanel("Plot", mainPanel(
          h1("Scatterplot of the Data"),
          plotOutput("plot"),
          textOutput("plotObservations")
         )),
        
          tabPanel("Table", mainPanel(
            h1("Summary Value Table of the Data"),
            tableOutput("table"),
            textOutput("median_bikes"),
            textOutput("median_solar"),
            h2("Column Number Key"), 
            p(strong(2), "- Median Number of Bikes Rented in the Month on a Given Day"),
            p(strong(3), "- Median Amount of Solar Radiation in the Month on a Given Day"),
            p(strong(4), "- Minimum Number of Bikes Rented in the Month on a Given Day"),
            p(strong(5), "- Maximum Number of Bikes Rented in the Month on a Given Day"),
            p(strong(6), "- Minimum Amount of Solar Radiation in the Month on a Given Day"),
            p(strong(5), "- Maximum Amount of Solar Radiation in the Month on a Given Day")
            
                      ))
                             
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
      ggplot(aes( solar_radiation,num_bikes_rented))+
      geom_point(col = input$color)+
      labs(title = "Comparing the Amount of Solar Radiation to Number of Bikes Rented", x="Amount of Solar Radiation in MJ/m2" , y="Number of Bikes Rented" )
  })
  
  output$table <- renderTable({
    table <- bikes %>% 
      filter(!is.na(solar_radiation), !is.na(num_bikes_rented), month %in% input$month) %>% 
      group_by(month) %>% 
      summarize(median_bikes = median(num_bikes_rented), median_solar = median(solar_radiation), min_bikes = min(num_bikes_rented), max_bikes = max(num_bikes_rented), min_solar = min(solar_radiation), max_solar = max(solar_radiation)) %>% 
      select(input$column)
      
    })
  
  output$full <- renderTable({
    bikes %>% 
      filter(!is.na(solar_radiation), !is.na(num_bikes_rented)) %>% 
      group_by(month) %>% 
      summarize(median_bikes = median(num_bikes_rented), median_solar = median(solar_radiation), min_bikes = min(num_bikes_rented), max_bikes = max(num_bikes_rented), min_solar = min(solar_radiation), max_solar = max(solar_radiation))
  })
  
  output$plotObservations <- renderText({
    x <- bikes %>% 
      filter(month %in% input$month) %>% 
      nrow()
    
    
      paste("In month", input$month, "there are", x, "observations.")
  })
  
  output$median_bikes <- renderText({
    y <- bikes %>% 
      filter(month %in% input$month) %>% 
      summarize(median_bikes = median(num_bikes_rented))
    
    paste("In month", input$month, "the median number of bikes was", y)
    
  })
  
  output$median_solar <- renderText({
    a <- bikes %>% 
      filter(month %in% input$month) %>% 
      summarize(median_solar = median(solar_radiation))
    
    paste("In month", input$month, "the median amount of solar radiation was", a, "MJ/m2")
    
  })
  


}  

shinyApp(ui = ui, server = server)


