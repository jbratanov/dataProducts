

library(shiny)


# Server logic required to summarize and view the selected
# State, medical condition and ranking
shinyServer(function(input, output) {
  
  # By declaring dataInput as a reactive expression we ensure 
  # that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers 
  #    (it only executes a single time)
  #
  dataInput <- reactive({
    switch(input$state, state.abb)
  })
  
  # Run hospital ranking file against parameters from ui.R
  output$summary <- renderText({
    # initiative vars
    state_df <- data.frame()
    # Read outcome file
    outcomeFile = read.csv("./outcome-of-care-measures.csv", colClasses="character", header= TRUE)
    # Get state data
    state_df <- subset(outcomeFile, subset=(State == input$state))
    if (nrow(state_df) == 0)
    {
      stop("invalid USA State Name")
    }
    # Get outcome data for state
    if (input$condition == "heart attack")
    {
      state_df[,11] <- as.numeric(state_df[,11])
      hospData <- state_df[order(state_df[,11], state_df$Hospital.Name),]
    }                          
    else if (input$condition == "heart failure")
    {
      state_df[,17] <- as.numeric(state_df[,17])
      hospData <- state_df[order(state_df[,17], state_df$Hospital.Name),]
    }                        
    else if (input$condition == "pneumonia")
    {
      state_df[,23] <- as.numeric(state_df[,23])
      hospData <- state_df[order(state_df[,23], state_df$Hospital.Name),]
    }
    else
    {
      stop("Invalid Medical Condition")
    }
    # Omit NAs to count
    best <- na.omit(hospData)
    # print rank answer
    if (input$ranking == "best")
    {
      hospData$Hospital.Name[1]
    } 
    else if (input$ranking == "worst")
    {
      worst <- nrow(hospData)
      hospData$Hospital.Name[worst]
    }
    else
      stop("Invalid Ranking Request")

 
})


})
