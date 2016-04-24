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



# Merge the test and training data for X, Y and subject dataframes
x_all<-rbind(x_train,x_test)
y_all<-rbind(y_train,y_test)
subject_all<-rbind(subject_train,subject_test)

# Get the column numbers of only the measurements with 'mean' and 'std' in their names
readmeasures <- read.table("features.txt", sep = "")
setwd( "..")

# This code selects only the columns that have 'mean' or 'std' in the measure
# name
selectmeasures <- readmeasures[grepl("mean",readmeasures$V2) | grepl("std",readmeasures$V2),]
x_select<-x_all[,selectmeasures$V1]

# Apply the selected measure names to the selected columns in X
names(x_select)<-selectmeasures$V2

# Provide the "subject" column name
names(subject_all)<-"subject"

# This code  replaces the activty codes with descriptive activity names
y_allnamed<-merge(x=y_all,y=readactivity,by.x="V1",by.y="V1",all.x=TRUE,sort=FALSE)
names(y_allnamed)<-c("activitycode","activity")

# dataframe 'combined' combines the X, Y, subject and activity columns into one
# dataframe, and provides the column name 'activity' 
combined<-cbind(subject_all,activity=y_allnamed[,-1],x_select)

# dataframe 'final' is the dataframe of tidy data containing the mean of each 
# measure for each subject-activity combination
final<-summarise_each(group_by(combined,subject,activity),funs(mean))


# This code writes the final tidy dataframe to the file 'tidy.txt"
write.table(x = final,file = "tidydata.txt",row.name=FALSE)

