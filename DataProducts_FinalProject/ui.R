# Final Project ui.R

library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Toronto Death Statistics"),
    sidebarPanel(
        checkboxGroupInput("civic_centre","Region",
                           c("Toronto" = "TO",
                             "Etobicoke" = "ET",
                             "North York" = "NY",
                             "Scarborough" = "SC"),
                           selected = c("Toronto","Etobicoke","North York","Scarborough")),
        checkboxGroupInput("year","Year",
                           c("2011" = "2011",
                             "2012" = "2012",
                             "2013" = "2013",
                             "2014" = "2014",
                             "2015" = "2015"),
                           selected = c("2011","2012","2013","2014","2015"))
    ),
    mainPanel(
        p('Total Deaths over Period: '),
        textOutput('total_deaths'),
        plotOutput('dotPlot')
    )
))