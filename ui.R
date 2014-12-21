library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Predict Maximum Dose of Theophylline"),
    sidebarPanel(
        h3('Documentation for this Application'),
        h4('This application calculates the maximum dose of the drug,'),
        h4('Theophylline. This is important because the maximum dose'),
        h4('is the effective dose and needs to be in a certain range'),
        h4('Input values amount of drug in mg and weight in kg'),
        h4('Values are adjusted using the up and down arrows'),
        numericInput('Amount', 'Amount in mg (Values between 250 and 350)', 320, min=250, max=350, step=10),
        numericInput('Wt', 'Weight in kg (Values between 50 and 90)',70, min=50, max=90, step=5)
        ),
    mainPanel(
        h3('Check Input values'),
        h4('You entered'),
        verbatimTextOutput("oAmount"),
        h4('You entered'),
        verbatimTextOutput("oWt"),
        h3('Results'),
        h4('Your maximum dose range in mg/L'),
        verbatimTextOutput("results")
        )
    ))