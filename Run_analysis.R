#This code aim to prepare clean data set in Getting and Cleaning Data Course Project

##Download data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
data = unzip(temp, files = NULL, list = FALSE, overwrite = TRUE,
              junkpaths = FALSE, exdir = ".", unzip = "internal",
              setTimes = FALSE)
#[1] "./UCI HAR Dataset/activity_labels.txt"                         
#[2] "./UCI HAR Dataset/features.txt"                                
#[3] "./UCI HAR Dataset/features_info.txt"                           
#[4] "./UCI HAR Dataset/README.txt"                                  
#[5] "./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"   
#[6] "./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"   
#[7] "./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"   
#[8] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"  
#[9] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"  
#[10] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"  
#[11] "./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"  
#[12] "./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"  
#[13] "./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"  
#[14] "./UCI HAR Dataset/test/subject_test.txt"                       
#[15] "./UCI HAR Dataset/test/X_test.txt"                             
#[16] "./UCI HAR Dataset/test/y_test.txt"                             
#[17] "./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt" 
#[18] "./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt" 
#[19] "./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt" 
#[20] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
#[21] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
#[22] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
#[23] "./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
#[24] "./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
#[25] "./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
#[26] "./UCI HAR Dataset/train/subject_train.txt"                     
#[27] "./UCI HAR Dataset/train/X_train.txt"                           
#[28] "./UCI HAR Dataset/train/y_train.txt"

test <- read.csv(data[15], header = T, sep = ",", quote = "\"",
                  dec = ".", fill = T)
X_test <- read.table(data[15])
y_test <- read.table(data[16])
X_train <- read.table(data[27])
y_train <- read.table(data[28])
features <- read.table(data[2])
colnames(X_test) <- features$V2
colnames(X_train) <- features$V2
colnames(y_test) <- "labels"
colnames(y_train) <- "labels"

subject_test <- read.table(data[14])
subject_train <- read.table(data[26])
colnames(subject_test) <- "subject"
colnames(subject_train) <- "subject"

features <- read.table(data[2])
colnames(features) = c("n","features")
activities <- read.table(data[1])
colnames(activities) = c("n","activity")

##merge test and train data together
data_X <- rbind(X_test, X_train)
data_Y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)
merge_data <- cbind(subject, data_X, data_Y)

##Extracts only the measurements on the mean and standard deviation for each measurement
t.index1 = grep("mean", colnames(merge_data))
t.index2 = grep("std", colnames(merge_data))
t.index = unique(c(t.index1, t.index2))
tidy_data <- cbind(merge_data[, t.index], merge_data[ ,c("subject", "labels")])

##Uses descriptive activity names to name the activities in the data set
tidy_data$activity <- activities[tidy_data$labels, "activity"]

##Appropriately labels the data set with descriptive variable names

names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

##From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.
install.packages("dplyr")
library(dplyr)
tidy_data2 <- tidy_data %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(tidy_data2, "tidy_data2.txt", row.name=FALSE)
