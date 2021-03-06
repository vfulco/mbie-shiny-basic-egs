library(shiny)
library(ggvis)
library(dplyr)

load("ivs.rda")
load("dimensions.rda")

shinyServer(function(input, output, session) {
   
   
      
   #===================Define the headings====================================
   output$Heading1 <-renderText(paste0("<h3>", 
                                      input$MyCountry, 
                                      " : ",
                                      input$MyVariable,
                                      " (quarterly) </h3>"))
   
   output$Heading2 <-renderText(paste0("<h3>",
                                       input$MyVariable,
                                       " in year to ", max(ivs1$Year),
                                       " quarter ", unique(ivs1[ivs1$Period == max(ivs1$Period) , "Qtr"]),
                                       "</h3>"))
   
   
   
   #===================Time series plot==============
   #---------Define the data we need---------------
   TheData <- reactive({
      tmp <- ivs1 %>%
         filter(CountryGrouped %in% input$MyCountry & Variable %in% input$MyVariable)
      return(tmp)
   })
   
   #---------Define the plot and send to the UI---------------
   TheData %>%
       ggvis(x = ~Period, y = ~Value, stroke = ~CountryGrouped) %>%
       layer_lines() %>%
      bind_shiny("TimeSeriesPlot")
    
   #========================Dot chart=========================
   #---------Define the data we need---------------
   TheVariableData <- reactive({
      tmp <- ivs2 %>%
         filter(Variable %in% input$MyVariable) 
      
      return(tmp)
   })
   
   
   #---------Define the plot and send to the UI---------------
   TheVariableData %>%
      ggvis(y = ~CountryGrouped, x = ~Value, stroke = ~CountryGrouped, fill = ~CountryGrouped) %>%
      layer_points(size := 400) %>%
      bind_shiny("VariablePlot")
      
})
