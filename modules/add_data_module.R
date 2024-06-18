library(shiny)
library(jsonlite)
library(shinyjs)

add_data_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("name"), "Name:"),
    textInput(ns("surname"), "Surname:"),
    selectizeInput(ns("cars"),
                   label = "Select Cars",
                   choices = NULL,
                   multiple = TRUE),
    actionButton(ns("save_data"), "Save Data")
  )
}

add_data_module <- function(input, output, session) {

  updateSelectizeInput(session = session,
                       "cars",
                       label = "Select Cars",
                       choices = rownames(mtcars))

  observeEvent(input$save_data, {
    if (is.null(input$name) || input$name == "" ||
        is.null(input$surname) || input$surname == "" ||
        is.null(input$cars) || length(input$cars) == 0) {

      showModal(modalDialog(
        title = "Error",
        "Please fill in all fields.",
        easyClose = TRUE,
        footer = NULL
      ))

    } else {
      data <- list(
        name = input$name,
        surname = input$surname,
        cars = input$cars
      )
      json_data <- toJSON(data, pretty = TRUE)
      tryCatch({
        write(json_data, file = paste0("data/", input$name, "_data.json"))
        showModal(modalDialog(
          title = "Data Saved",
          "Your data has been saved successfully!",
          easyClose = TRUE,
          footer = NULL
        ))

        # Reset form inputs

        shinyjs::reset("name")
        shinyjs::reset("surname")
        shinyjs::reset("cars")


      }, error = function(e) {
        showModal(modalDialog(
          title = "Error",
          "There was an error saving your data.",
          easyClose = TRUE,
          footer = NULL
        ))
      })
    }
  })
}
