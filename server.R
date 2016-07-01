


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
  output$summary <- renderPrint({
    # initiative vars
    state_df <- data.frame()
    # Read outcome file
    outcomeFile = read.csv("./outcome-of-care-measures.csv", colClasses="character", header= TRUE)
    # Get state data
    state_df <- subset(outcomeFile, subset=(State == input$state))
    if (nrow(state_df) == 0)
    {
      stop("Error: invalid USA State Name")
    }
    # Get condition data for state
    if (input$condition == "heart attack")
    {
      suppressWarnings(state_df[,11] <- as.numeric(state_df[,11]))
      hospData <- state_df[order(state_df[,11], state_df$Hospital.Name),]
    }                          
    else if (input$condition == "heart failure")
    {
      suppressWarnings(state_df[,17] <- as.numeric(state_df[,17]))
      hospData <- state_df[order(state_df[,17], state_df$Hospital.Name),]
    }                        
    else if (input$condition == "pneumonia")
    {
      suppressWarnings(state_df[,23] <- as.numeric(state_df[,23]))
      hospData <- state_df[order(state_df[,23], state_df$Hospital.Name),]
    }
    else
    {
      stop("Error: Invalid Medical Condition")
    }
    # Omit NAs to count
    best <- na.omit(hospData)
    #suppressWarnings
    # print rank answer
    if (input$ranking == "best 10")
    {
      for (i in 1:10)
      {
        cat(i,hospData$Hospital.Name[i])
        if (i < 10)
          cat('\n')
      }
    } 
    else if (input$ranking == "worst 10")
    {
      worst <- nrow(hospData)
      
      for (i in 0:9)
      {

        cat(worst-i,hospData$Hospital.Name[worst-i])
        if (i < 10)
          cat('\n')
      }
    }
    else if (input$ranking == "all")
    {
      worst <- nrow(hospData)
      
      for (i in 1:nrow(hospData))
      {
        
        cat(i,hospData$Hospital.Name[i])
        if (i < nrow(hospData))
          cat('\n')
      }
    }
    else
      stop("Error: Invalid Ranking Request")

 
})


})
