library(shiny)

predictMaxDose<-function(Dose,Wt) {
    predict(fitobj4, Dose=Dose, recipWt=1/Wt,interval="prediction")
}
shinyServer(
    function(input,output) {
        output$oDose<-renderPrint({input$Dose})
        output$oWt<-renderPrint({input$Wt})
        output$results<-renderPrint({predictMaxDose(input$Dose,input$Wt)})
        }
    )