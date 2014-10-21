# This script does the following:
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each 
#        measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set
#       with the average of each variable for each activity and each subject.

# libraries
library(dplyr)
library(tidyr)

# Download and unzip the data
tFile <- tempfile()
fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" # https gives problems in Linux
dirName <- "data"
timeStamp <- Sys.time()
download.file(fileURL, tFile)
unzip(tFile)
unlink(tFile)


# Load the training and test data sets
subTrain <-  read.table("./UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

subTest <-  read.table("./UCI HAR Dataset/test/subject_test.txt")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")

xNames <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=F)


# Merge the training and test data sets
subjects <- rbind(subTrain, subTest)
x <- rbind(xTrain, xTest)
y <- rbind(yTrain, yTest)

# Merge all data into a single, sorted, data frame
data <- tbl_df(data.frame(subject=subjects[[1]], activity=y[[1]], x))
data %>%
        arrange(subject, activity)

# Cast the activities as a factor with levels describing the activity
data$activity <- as.factor(data$activity)
levels(data$activity) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                           "SITTING", "STANDING", "LAYING")

# Provide meangingful names for the variables
names(data)[-c(1, 2)] <- xNames[[2]]

# Select the means and standard deviations 
# testn <- data %>%
#         select(contains("std") | grepl("mean", names(data), ignore.case=T))

index <- grepl("std", names(data), ignore.case=T) | 
                grepl("mean", names(data), ignore.case=T)
index[1:2] <- T  # taking care to keep the subject and activity
subData <- data[, index] 

# The tidy data we want are the sample averages of each variable per subject per activity
tidyData <- subData %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))

# Write the tidyData to a file
tidyFile <- "tidyData.txt"
write.table(tidyData, tidyFile, row.names = FALSE)


