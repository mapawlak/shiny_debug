library(shiny)
library(shinyjs)
library(jsonlite)

# Source modules
source("modules/plot1_module.R")
source("modules/plot2_module.R")
source("modules/add_data_module.R")


# UI
ui <- fluidPage(
  useShinyjs(), # Initialize shinyjs
  tags$head(tags$script(HTML(js))), # Include JavaScript in the UI
  titlePanel("Demo Shiny app with a form"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("plot_choice",
                     "Choose Plot:",
                     choices = c("", "Histogram", "Scatter Plot"),
                     options = list(
                       placeholder = "select plot",
                       create = FALSE,
                       openOnFocus = FALSE,
                       closeAfterSelect = TRUE,
                       onDropdownOpen = I(
                         'function() {
        Shiny.setInputValue("plotDropdownOpen", true);
      }'
                       ),
                       onDropdownClose = I(
                         'function() {
          Shiny.setInputValue("plotDropdownOpen", false);
        }'
                       ))),
      actionButton("add_data", "Add Data")
    ),
    mainPanel(
      uiOutput("plot_ui"),
      uiOutput("form_ui")
    )
  )
)

# Server
server <- function(input, output, session) {

  plotDropdownOpen <- reactiveVal(FALSE)

  observeEvent(input$plotDropdownOpen, {
    plotDropdownOpen(input$plotDropdownOpen)
  })

  display_add_data_ui <- reactiveVal(FALSE)

  observeEvent({
    input$plotDropdownOpen
  }, {
    removeModal()
    display_add_data_ui(FALSE)
  })

  # Reactive value to store the chosen plot module
  plotModule <- reactive({
    switch(input$plot_choice,
           "Histogram" = plot1_module_ui("plot1"),
           "Scatter Plot" = plot2_module_ui("plot2"))
  })

  # Render the selected plot module UI
  output$plot_ui <- renderUI({
    plotModule()
  })

  # Call the selected plot module server function
  observe({
    req(input$plot_choice)
    if (input$plot_choice == "Histogram") {
      callModule(plot1_module, "plot1")
    } else if (input$plot_choice == "Scatter Plot") {
      callModule(plot2_module, "plot2")
    }
  })

  # Add Data button handler

  observeEvent(input$add_data, {
    display_add_data_ui(TRUE)
    message(paste0("display_add_data_ui is set to: ", display_add_data_ui()))
  })

  output$form_ui <- renderUI({
    if (display_add_data_ui()) {
      add_data_module_ui("add_data_form")
    } else {
      NULL
    }
  })

  observeEvent(display_add_data_ui(), {
    if (display_add_data_ui()) {
        callModule(add_data_module, "add_data_form")
    }
  })


}

# Run the application
shinyApp(ui = ui, server = server)
