library(shiny)
data(Theoph)
library(dplyr)

## find the maximum blood concentration
Theoph<-tbl_df(Theoph)
Theo_grp_subject<-group_by(Theoph,Subject)
Max_dose<-summarize(Theo_grp_subject,max(conc))
names(Max_dose)<-c("Subject", "MaxConc")
Max_dose<-arrange(Max_dose,Subject)
Theo_grp_subject<-merge(Theo_grp_subject,Max_dose, by="Subject")

## find the time at maximum blood concentration
MaxTime<-filter(Theo_grp_subject,conc==MaxConc)
MaxTime<-select(MaxTime, Subject, Time)
MaxTime<-arrange(MaxTime,Subject)
names(MaxTime)<-c("Subject","TimeAtMax")
Theo_grp_subject<-merge(Theo_grp_subject,MaxTime,by="Subject")


## Simplify and fit
MaxConcset<-filter(Theo_grp_subject,conc==MaxConc)
MaxConcset<-select(MaxConcset,Subject,Wt,Dose,MaxConc,TimeAtMax)
MaxConcset<-mutate(MaxConcset,recipWt = 1/Wt)
## The best fit is one with interactions allowed between recipWt (1/Wt)
## and Dose. 
fitobj4<-lm(MaxConc~recipWt * Dose, MaxConcset)

predictMaxDose<-function(Dose,Wt) {
    newdata<-as.data.frame(c(1,Wt,Dose,0.0, 0.0,1/Wt))
    predict(fitobj4, newdata,interval="prediction")
}
shinyServer(
    function(input,output) {
        output$oDose<-renderPrint({input$Dose})
        output$oWt<-renderPrint({input$Wt})
        output$results<-renderPrint({predictMaxDose(input$Dose,input$Wt)})
        }
    )