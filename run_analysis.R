#Load data from web and unzip archive
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip"
download.file(fileUrl, "rawdata.zip", method="curl")
unzip("rawdata.zip")

#import data and labels
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
names<-read.table("UCI HAR Dataset/features.txt")
feat_names<-as.vector(names$V2)
Y_test<-read.table("UCI HAR Dataset/test/Y_test.txt")
Y_train<-read.table("UCI HAR Dataset/train/Y_train.txt")
Y_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
colnames(Y_labels)<-c("activitycode", "activitydesc")

#combine data, first X/Y/subject, and then test and train (Step 1)
X_test<-cbind(X_test, Y_test, subj_test)
X_train<-cbind(X_train, Y_train, subj_train)
merged<-rbind(X_test, X_train)

#label columns using feature names (Step 4)
colnames(merged)<-c("subject", feat_names, "activitycode")

#screen out all but mean, std, activity code, and subject columns (Step 2)
#Regex is patterned to exclude the dimensions where "mean" occurs
#without actually referring to a mean value
screened<-merged[,grep(".mean\\(\\).|$|.std\\(\\).|$|.code|subject", colnames(merged))]

#import descriptive labels from Y labels (Step 3)
screened$activitydesc<-Y_labels$activitydesc[match(screened$activitycode, Y_labels$activitycode)]

#create second dataset with averages for selected values (Step 5)
library(dplyr)
grouped<- screened %>% group_by(subject, activitydesc) %>%
  summarize_all(funs(mean))
write.table(grouped, "summarizedData.txt", row.name = FALSE)


