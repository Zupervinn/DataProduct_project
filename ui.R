library(shiny)
library(shinydashboard)


# Define UI for application that draws a histogram
shinyUI(fluidPage( theme = 'bstheme.css',
        
                   
        
        titlePanel("Understanding the cost of ownership on new/used car"),
      
        
        
        # Sidebar with a slider input for the number of bins
        sidebarLayout(
                sidebarPanel(
                        
                        radioButtons('ownership', label=h5('Ownership:'), 
                                      choices = c('Owned', 'Financed')),
                        
                        conditionalPanel(
                                condition = "input.ownership == 'Financed'",
                                numericInput('apr', 'APR:', value = 3.25, step = .01) 
                        ),
                        
                        numericInput('length', 'Length of ownership(1-5 year/s):', min=1, max=5, step=1, value=5),
                       
                       sliderInput("purchased", "Out-the-door cost:", min=0, max=100000, value=20000, step=50, pre='$', sep=','),
                       numericInput('mpg', 'Average MPG:', value = 30, step=1),
                       numericInput('gas', 'Gas price/gallon:', value = 2.89, step =.01),
                       actionButton('estimate', 'Estimate!'),
                   
                       helpText('Note: This estimate only takes into account of the depreciation, interests from financing if 
                                any and your fuel consumption. Fuel consumption is based off 13,476 miles/year.')
                       
                       
                   
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        h5('Estimating.....'),
                        h5(textOutput('nText')),
                        
                        img(src="evora.jpg")
                )
                )
        )
)