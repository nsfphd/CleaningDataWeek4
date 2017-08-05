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

#combine data, first X&Y, and then test and train (Step 1)
X_test<-cbind(X_test, Y_test)
X_train<-cbind(X_train, Y_train)
merged<-rbind(X_test, X_train)

#label columns using feature names
colnames(merged)<-c(feat_names, "activitycode")

#screen out all but mean, std, and activity code columns (Step 2)
#Regex is patterned to exclude the "*-Freq" values
screened<-merged[,grep(".mean\\(\\).|.std\\(\\).|.code", colnames(merged))]

#import descriptive labels from Y labels (Step 3 & 4)
screened$activitydesc<-Y_labels$activitydesc[match(screened$activitycode, Y_labels$activitycode)]

#create second dataset with averages for selected values (Step 5)
library(dplyr)
grouped<- screened %>% group_by(activitydesc) %>%
  summarize_all(funs(mean))

