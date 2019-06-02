#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Chile Voting Predictor"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      numericInput('age', 'Age of Voter', 25, min = 18, max = 100, step = 1),
      numericInput('income', 'Monthly Income of Person', 35000, min = 25000, max = 250000, step = 5000),
      radioButtons('region', "Region of Person",
                   c("Central" = "C",
                     "Metropolitan Santiago Area" = "M",
                     "North" = "N",
                     "South" = "S",
                     "Santiago City" = "SA")),
      radioButtons('sex', "Sex of Person",
                   c("Female" = "F",
                     "Male" = "M")),
      numericInput('statusquo', 'Statusquo of Voter', 1, min = -1.72, max = 1.72, step = .2),
      radioButtons('education', "Education of Person",
                   c("Primary" = "P",
                     "Post-secondary" = "PS",
                     "Secondary" = "S")),
      submitButton('Submit'),
      width = 3
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       h3('Results of the Prediction is'),
       verbatimTextOutput("prediction"),
       h3('Plots for the existing distribution of Chile Popluation'),
       plotOutput("distPlot"),
       h5("Possible outcomes of Predications are:" , 
          strong("A - Abstain from Voting, N - Will Not Vote, U - Undecided, Y - Will Vote")),
       width = 9
    )
  )
))
