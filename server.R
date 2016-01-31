library(shiny)


financed <- function(P=500000, I=6, L=30, amort=T) { 
        J <- I/(12 * 100)
        N <- 12 * L
        M <- P*J/(1-(1+J)^(-N))
        monthPay <<- M
        
        # Calculate Amortization for each Month
        if(amort==T) {
                Pt <- P # current principal or amount of the loan
                currP <- NULL
                while(Pt>=0) {
                        H <- Pt * J # this is the current monthly interest
                        C <- M - H # this is your monthly payment minus your monthly interest, so it is the amount of principal you pay for that month
                        Q <- Pt - C # this is the new balance of your principal of your loan
                        Pt <- Q # sets P equal to Q and goes back to step 1. The loop continues until the value Q (and hence P) goes to zero
                        currP <- c(currP, Pt)
                }
                monthP <- c(P, currP[1:(length(currP)-1)])-currP
                aDFmonth <<- data.frame(
                        Amortization=c(P, currP[1:(length(currP)-1)]), 
                        Monthly_Payment=monthP+c((monthPay-monthP)[1:(length(monthP)-1)],0),
                        Monthly_Principal=monthP, 
                        Monthly_Interest=c((monthPay-monthP)[1:(length(monthP)-1)],0), 
                        Year=sort(rep(1:ceiling(N/12), 12))[1:length(monthP)]
                )
                aDFyear <- data.frame(
                        Amortization=tapply(aDFmonth$Amortization, aDFmonth$Year, max), 
                        Annual_Payment=tapply(aDFmonth$Monthly_Payment, aDFmonth$Year, sum), 
                        Annual_Principal=tapply(aDFmonth$Monthly_Principal, aDFmonth$Year, sum), 
                        Annual_Interest=tapply(aDFmonth$Monthly_Interest, aDFmonth$Year, sum), 
                        Year=as.vector(na.omit(unique(aDFmonth$Year)))
                )
                aDFyear <<- aDFyear
                
        }
        if(L==1){
                print(aDFyear[1,4])
        }
        else if(L==2){
                print(sum(aDFyear[1:2,4]))
        }
        else if(L==3){
                print(sum(aDFyear[1:3,4]))
        }
        else if(L==4){
                print(sum(aDFyear[1:4,4]))
        }
        else{
                print(sum(aDFyear[1:5,4]))
        }
}




# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        
        ntext <- eventReactive(input$estimate,{
                
               
                #owned
                if (input$ownership == 'Owned'){
                        interests <- 0
                }
                #financed
                else{interests <- financed(P=input$purchased, I=input$apr, L=input$length,T)
                }
                
                # depreciation by year
                if (input$length == 1){
                        depreciation = .19
                }
                
                else if(input$length == 2){
                        depreciation = .31
                }
                
                else if(input$length==3){
                        depreciation = .42
                }
                else if(input$length==4){
                        depreciation = .51
                }
                else{
                        depreciation = .6
                }
                
                #average 13,476 miles/year according to fhwa.dot.gov/ohim/onh00/bar8.html
                
                fuel <- 13476/input$mpg*input$gas
                
             
                        
                cost <- input$purchased
                
               
                x <- cost * depreciation + interests + (fuel*input$length)
               
                format(x, big.mark=',', nsmall=2, digits=2)
                
              
        
        })
        
        output$nText <- renderText({
                paste('Your estimated', input$length,'year(s) cost of ownership is $',ntext(),'!')
               
                
                
        })
        })

