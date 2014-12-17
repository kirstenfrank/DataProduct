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
fitobj<-lm(MaxConc~Wt + Dose, MaxConcset)
fitobj2<-lm(MaxConc~recipWt + Dose,MaxConcset)
fitobj3<-lm(MaxConc~recipWt + Dose + TimeAtMax, MaxConcset)
fitobj4<-lm(MaxConc~recipWt * Dose, MaxConcset)
anova(fitobj2,fitobj4)
## Fitobj4, which includes the interaction term between 1/Wt and Dose
## is the best fit. Adjusted R-squared is the highest. 
predictvalues<-predict(fitobj4,MaxConcset, interval="prediction")

## Use this model in an interactive Shiny app to predict a person's maximum
## concentration of Theophylline (an anti-asthmatic drug) based on the 
## dose taken and the weight of the person.