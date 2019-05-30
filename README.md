# Getting-and-Cleaning-Data-Course-Project
#This code aim to prepare clean data set in Getting and Cleaning Data Course Project

##Download data, unzip data and store all the names in "data"
##read each table and add colnames on it
##merge X, Y, subject together by column bind
##Extracts only the measurements on the mean and standard deviation for each measurement to get tidy data
##Uses descriptive activity names to name the activities in the data set
tidy_data$activity <- activities[tidy_data$labels, "activity"]

##Appropriately labels the data set with descriptive variable names

##From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject to get tidy_data2.
tidy_data2:
