# Final Project server.R

library(shiny)
library(lubridate)
library(dplyr)
library(reshape2)
library(ggplot2)

death_url<-"http://opendata.toronto.ca/clerk/registry.service/death.csv"
deathDF <- read.csv(url(death_url))
deathDF <- dcast(deathDF, TIME_PERIOD + CIVIC_CENTRE ~ PLACE_OF_DEATH, 
                 value.var = "DEATH_LICENSES", fill = 0)
names(deathDF) <- gsub(" ","", names(deathDF), fixed=TRUE)
deathDF <- transmute(deathDF, TIME_PERIOD = TIME_PERIOD,
                     CIVIC_CENTRE = CIVIC_CENTRE, deaths = Toronto + OutsideCityLimits)
deathDF[,"date"] <- ymd(as.character(deathDF$TIME_PERIOD), truncated = 2)
deathDF[,"year"] <- as.factor(substr(deathDF$TIME_PERIOD, start=1, stop=4))

shinyServer(
    function(input,output) {
        output$dotPlot <- renderPlot({
            myDF <- filter(deathDF, year %in% input$year & CIVIC_CENTRE %in% input$civic_centre)            
            g <- ggplot(myDF,aes(x = date, y=deaths, colour = CIVIC_CENTRE))
            g <- g + geom_line(size=3) + facet_grid(CIVIC_CENTRE ~ .)
            g
        })
        output$total_deaths <- renderPrint({sum(filter(deathDF, year %in% input$year & CIVIC_CENTRE %in% input$civic_centre)$deaths)})
    }
)