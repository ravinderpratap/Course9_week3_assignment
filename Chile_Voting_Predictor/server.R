#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#' Chile Prediction model to predict whether person will vote or not?
#' 
#' @param df, dataframe to specify the details captured from Application options
#' @return predict1, Text output containg the prediction for the voter.
#' 
library(shiny)
library(carData)
data(Chile)
library(dplyr)
library(ggplot2)
library(caret)
library(e1071)
library(randomForest)

#function to Predict the voting
chile_predict <- function(df){
  
  chile_data <-  as.data.frame(Chile)
  chile_data <- na.omit(chile_data) %>%
    select(-population)  
  
  set.seed(5)
  inTrain = createDataPartition(chile_data$vote, p = 3/4)[[1]]
  training = chile_data[ inTrain,]
  validation = chile_data[-inTrain,]
  
  train_rf <-  randomForest(vote ~. , data=training, method="class")
  pred_rf <- predict(train_rf, validation, method="class")
  
  percent <- confusionMatrix(pred_rf, validation$vote)$overall["Accuracy"]
  
  df <- rbind(validation, df)
  df <- df[nrow(df),]
  
  predict1 <- predict(train_rf, df)
  
  if (predict1 == 'A') {
    predict1 <- "Will Abstain From Voting"
  }
  if (predict1 == 'N') {
    predict1 <- "Will Not Go For Voting"
  }
  if (predict1 == 'U') {
    predict1 <- "Will be Undecided for Voting"
  }
  if (predict1 == 'Y') {
    predict1 <- "Will Go For Voting"
  }
  
  percent <- ceiling(percent * 100)
  
  predict1 <- paste("There are",percent,"% chances that Person", predict1)
  return(predict1)
  
}

# Function to plot it
#' Chile Prediction model to draw the plot
#' @param df, dataframe to specify the details captured from Application options
#' @return g1, ggplot output containg the graphical representation of the prediction over existing population.
#' 
chile_plot <- function(df){
  
  chile_data <-  as.data.frame(Chile)
  chile_data <- na.omit(chile_data) %>%
    select(-population)  
  
  set.seed(5)
  inTrain = createDataPartition(chile_data$vote, p = 3/4)[[1]]
  training = chile_data[ inTrain,]
  validation = chile_data[-inTrain,]
  
  train_rf <-  randomForest(vote ~. , data=training, method="class")
  pred_rf <- predict(train_rf, validation, method="class")
  
  df <- rbind(validation, df)
  df <- df[nrow(df),]
  
  predict1 <- predict(train_rf, df)
  df$vote <- predict1

  g1 <- ggplot(data = chile_data, aes(x=as.numeric(age), y = as.numeric(income), color = education )) +
    geom_point() + 
    facet_grid(vote ~ sex + region) +
    ylab("Income Per Month") +
    xlab("Age of Voter") + 
    ggtitle("Voting predictor - Prediction shown in Black Color")
  
  g1 <- g1 + geom_point(data = df, color = "black", size=3)
  
  return(g1)
  
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$prediction <- renderPrint({
    df <- c(input$region, input$sex,input$age, input$education,input$income, input$statusquo, 'N')
    chile_predict(df)
    })
  
  output$distPlot <- renderPlot({
    df <- c(input$region, input$sex,input$age, input$education,input$income, input$statusquo, 'N')
    chile_plot(df)
  })
  
})
