#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define functions for simulating evolution
mutate <- function(seq){
  ### procedure to mutate the sequence in each generation
  L <- length(seq)
  S <- sample(1:L, 1) # pick the sites to mutate 
  m <- seq[S] + sample(1:3, 1, T) # this adds a random integer between 1-3 to the original value.
  seq[S] <- m %% 4 # this will take anything greater than 3 to "circle back"
  return(seq)
}

evolve <- function(seq, N){
  ### throw N mutations
  seqs <- list(seq) # record the genotype of each generation
  Nobs <- 0   # counter for the number of *observed* mutations
  for( i in 1:N ){
    seq <- mutate(seq) # perform mutation
    seqs <- c(seqs, list(seq)) # record the genotype at this generation
    Nobs <- c(Nobs, sum(seqs[[1]] != seq)) # this records the number of *observed* mutations
  }
  return(list(seqs, 0:N, Nobs))
}

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Demonstrate DNA sequence divergence"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            numericInput("seqL",
                         "Sequence length (nt):",
                         min = 1,
                         max = 100,
                         value = 30),
            sliderInput("mutation",
                        "Number of mutations:",
                        min = 0,
                        max = 300,
                        value = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
