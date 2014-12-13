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
Theo_grp_Subject<-merge(Theo_grp_subject,MaxTime,by="Subject")
