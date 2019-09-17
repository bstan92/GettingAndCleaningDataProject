#setwd


#read in data
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

#merge training and test data sets
data_subject <- rbind(subject_test, subject_train)
names(data_subject)[1] <- "Subject"


data_y <- rbind(y_test, y_train)
names(data_y)[1] <- "Activity"

data_x <- rbind(x_test, x_train)
names(data_x) <- features$V2

full_data <- cbind(data_subject, data_y, data_x)


#Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std_vars <- names(full_data)[grep("mean|std",colnames(full_data))]
mean_and_std <- full_data[c("Subject","Activity",mean_and_std_vars)]



#Uses descriptive activity names to name the activities in the data set
mean_and_std$Activity <- activities[mean_and_std$Activity,2]


mas2 <- mean_and_std

#Appropriately labels the data set with descriptive variable names.
names(mas2) <- gsub("Acc","Accelerometer", names(mas2))
names(mas2) <- gsub("Mag","Magnitude", names(mas2))
names(mas2) <- gsub("Gyro","Gyroscope", names(mas2))
names(mas2) <- gsub("BodyBody","Body", names(mas2))
names(mas2) <- gsub("gravity","Gravity", names(mas2))
names(mas2) <- gsub("angle","Angle", names(mas2))
names(mas2) <- gsub("^f","Frequency", names(mas2))
names(mas2) <- gsub("^t","Time", names(mas2))
names(mas2) <- gsub("-mean()", "Mean", names(mas2), ignore.case = TRUE)
names(mas2) <- gsub("-freq()", "Frequency", names(mas2), ignore.case = TRUE)
names(mas2) <- gsub("-std()", "StdDev", names(mas2), ignore.case = TRUE)

names(mas2)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
summarizedData <- mas2 %>% 
  group_by(Subject, Activity) %>%
  summarise_all(funs(mean))
  
write.table(summarizedData,"summarizedData.txt", row.names = FALSE)
