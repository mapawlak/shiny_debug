library(shiny)
library(ggplot2)

plot1_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("histogram_plot"))
  )
}

plot1_module <- function(input, output, session) {
  output$histogram_plot <- renderPlot({
    ggplot(mtcars, aes(x = mpg)) +
      geom_histogram(binwidth = 2, fill = "blue", color = "white")
  })
}
