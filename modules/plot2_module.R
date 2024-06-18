library(shiny)
library(ggplot2)

plot2_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("scatter_plot"))
  )
}

plot2_module <- function(input, output, session) {
  output$scatter_plot <- renderPlot({
    ggplot(mtcars, aes(x = wt, y = mpg)) +
      geom_point(color = "red")
  })
}
