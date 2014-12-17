library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Predict Maximum Dose of Theophylline"),
    sidebarPanel(
        h3('Input values dose in mg/kg and weight in kg'),
        numericInput('Dose', 'Dose in mg/kg', 0, min=0, max=10, step=0.1),
        numericInput('Wt', 'Weight in kg',0, min=0, max=150, step=10)
        ),
    mainPanel(
        h3('Check Input values'),
        h4('You entered'),
        verbatimTextOutput("oDose"),
        h4('You entered'),
        verbatimTextOutput("oWt")
        )
    ))