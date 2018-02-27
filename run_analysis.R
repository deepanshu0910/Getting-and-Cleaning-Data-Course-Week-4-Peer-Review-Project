
### * Merges the training and the test sets to create one data set.

## Reading data from test folder
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
SubjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Reading data from train folder
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
SubjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

Features <- read.table('./UCI HAR Dataset/features.txt') ## Reading feature file
ActivityLabels = read.table('./UCI HAR Dataset/activity_labels.txt') ## Reading activity_labels file

## Naming columns
colnames(XTest) <- Features[,2] 
colnames(YTest) <- "activity_id"
colnames(SubjectTest) <- "subject_id"
colnames(XTrain) <- Features[,2] 
colnames(YTrain) <-"activity_id"
colnames(SubjectTrain) <- "subject_id"
colnames(ActivityLabels) <- c('activity_id','activity_type')

##Merging data in one set:
m_test <- cbind(YTest, SubjectTest, XTest)  
m_train <- cbind(YTrain, SubjectTrain, XTrain)
one_data_set <- rbind(m_train, m_test) ## Merged data set

### * Extracts only the measurements on the mean and standard deviation for each measurement.
  
column_names <- colnames(one_data_set) ##Reading names of columns in in_one
#Create vector for defining ID, mean and standard deviation:
mean_n_standard_dev <- (grepl("activity_id" , column_names) | grepl("subject_id" , column_names) | grepl("mean.." , column_names) | grepl("std.." , column_names))
#Subsetting from one_data_set:
set_for_mean_n_standard_dev <- one_data_set[ , mean_n_standard_dev == TRUE]    

### * Uses descriptive activity names to name the activities in the data set.
### * Appropriately labels the data set with descriptive variable names.

set_with_activity_names <- merge(set_for_mean_n_standard_dev, ActivityLabels, by='activity_id', all.x=TRUE)

### * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidySet <- aggregate(. ~subject_id + activity_id, set_with_activity_names, mean)
TidySet <- TidySet[order(TidySet$subject_id, TidySet$activity_id),]
write.table(TidySet, "TidySet.txt", row.name=FALSE) #Writing second tidy data set in txt file