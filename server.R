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
newdata<-data.frame(matrix(data=NA,nrow=1,ncol=6))
names(newdata)<-c("Subject","Wt","Dose","MaxConc","TimeAtMax","recipWt")

predictMaxDose<-function(Amount,Wt) {
    newdata$Wt<-Wt
    newdata$Dose<-Amount/Wt
    newdata$recipWt<-1/Wt
    predict(fitobj4, newdata,interval="prediction")
}
shinyServer(
    function(input,output) {
        output$oAmount<-renderPrint({input$Amount})
        output$oWt<-renderPrint({input$Wt})
        output$results<-renderPrint({predictMaxDose(input$Amount,input$Wt)})
        }
    )