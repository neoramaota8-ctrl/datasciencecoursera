# 1. Download and unzip the dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", mode = "wb")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# 2. Read the data into tables
path_rf <- file.path("./data" , "UCI HAR Dataset")
features <- read.table(file.path(path_rf, "features.txt"), col.names = c("index", "featureName"))
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"), col.names = c("classLabels", "activityName"))

subjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"), col.names = "subject")
xTrain <- read.table(file.path(path_rf, "train", "X_train.txt"))
yTrain <- read.table(file.path(path_rf, "train", "y_train.txt"), col.names = "activity")

subjectTest <- read.table(file.path(path_rf, "test", "subject_test.txt"), col.names = "subject")
xTest <- read.table(file.path(path_rf, "test", "X_test.txt"))
yTest <- read.table(file.path(path_rf, "test", "y_test.txt"), col.names = "activity")

# 3. Merge the training and test sets
subject <- rbind(subjectTrain, subjectTest)
xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
colnames(xData) <- features$featureName
mergedData <- cbind(subject, yData, xData)

# 4. Extract only mean and standard deviation measurements
meanStdFeatures <- grep("mean\\(\\)|std\\(\\)", features$featureName, value=TRUE)
extractedData <- mergedData[, c("subject", "activity", meanStdFeatures)]

# 5. Use descriptive activity names
extractedData$activity <- factor(extractedData$activity, levels = activityLabels$classLabels, labels = activityLabels$activityName)

# 6. Label with descriptive variable names
names(extractedData) <- gsub("^t", "Time", names(extractedData))
names(extractedData) <- gsub("^f", "Frequency", names(extractedData))
names(extractedData) <- gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData) <- gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData) <- gsub("Mag", "Magnitude", names(extractedData))
names(extractedData) <- gsub("BodyBody", "Body", names(extractedData))
names(extractedData) <- gsub("mean\\(\\)", "Mean", names(extractedData))
names(extractedData) <- gsub("std\\(\\)", "StdDev", names(extractedData))
names(extractedData) <- gsub("-", "", names(extractedData))

# 7. Create a second, independent tidy data set with the average
tidyData <- aggregate(. ~ subject + activity, data = extractedData, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity), ]

# 8. Write the final data to a text file
write.table(tidyData, "tidy_data.txt", row.names = FALSE)
print("Done! Check your files tab for tidy_data.txt")
