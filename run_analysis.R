library(dplyr)
library(tidyr)


setwd( "UCI HAR Dataset/")

# Read the test and training tables
x_train <- read.table("train/X_train.txt", sep = "")
x_test <- read.table("test/X_test.txt", sep = "")

y_train <- read.table("train/y_train.txt", sep = "")
y_test <- read.table("test/y_test.txt", sep = "")

subject_train <- read.table("train/subject_train.txt", sep = "")
subject_test <- read.table("test/subject_test.txt", sep = "")

readactivity <- read.table("activity_labels.txt", sep = "")
activity <- as.character(readactivity$V2)

# Merge the test and training into one dataframe
x_all<-rbind(x_train,x_test)
y_all<-rbind(y_train,y_test)
subject_all<-rbind(subject_train,subject_test)

# Get the column numbers of only the measurements with 'mean' and 'std' in their names
readmeasures <- read.table("features.txt", sep = "")
#temp[grepl("mean",temp$V2) | grepl("std",temp$V2),]

selectmeasures <- readmeasures[grepl("mean",readmeasures$V2) | grepl("std",readmeasures$V2),]

x_select<-x_all[,selectmeasures$V1]

names(x_select)<-selectmeasures$V2
#names(y_all)<-"activitycode"
names(subject_all)<-"subject"

y_allnamed<-merge(x=y_all,y=readactivity,by.x="V1",by.y="V1",all.x=TRUE,sort=FALSE)

names(y_allnamed)<-c("activitycode","activity")

combined<-cbind(subject_all,activity=y_allnamed[,-1],x_select)

setwd( "..")