

library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hospital Rankings"),
  
  # Sidebar with controls to select a State, Medical Condition and Hospital Ranking
  # and specify the number of "Best" or "Worst" hospitals observations to view with
  # number of hospitals to be shown.
  sidebarLayout(
    sidebarPanel(
  
      selectInput("state", "Choose a State:", 
                  choices = c(state.abb)),
      
      selectInput("condition", "Choose Medical Condition:", 
                  choices = c("heart attack", "heart failure", "pneumonia")),
      
      selectInput("ranking", "Choose a Ranking:", 
                  choices = c("best", "worst")),
      
      selectInput("dispCnt", "Display 1-10 Hospitals", 
                  choices = c(1:10))
      
    ),
    
    
    # Show the caption and summary of hospitals
    mainPanel(
      
      verbatimTextOutput("summary")
      
    )
  )
))
