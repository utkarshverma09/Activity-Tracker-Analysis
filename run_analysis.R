library(dplyr)
#checking if it exist
folderName<-"FinalProject.zip"
if(!file.exists(folderName)){
	fileURL<-fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 	download.file(fileURL, filename, method="curl")
}
if(!file.exists("UCI HAR Dataset")){
	#unzipping
	unzip(folderName)
}


#assigning data frames to their respective variables
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("number","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dat aset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#binding
XBinded <- rbind(x_train, x_test)
YBinded <- rbind(y_train, y_test)
SubjectBinded <- rbind(subject_train, subject_test)
MergedData <- cbind(SubjectBinded, YBinded, XBinded)

#extracting all the measurements on mean and standard deviation
TidyData <- select(MergedData, subject, code, contains("mean"), contains("std"))
TidyData$code<-activities[TidyData$code, 2]
#setting up apt names

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "Standard Deviation", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
#average of each variable and exporting to text file
Final <- TidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(Final, "tidyData.txt", row.name=FALSE)
