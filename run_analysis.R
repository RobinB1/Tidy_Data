## Getting Files
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Merging the training and test sets to create one dataset
# Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

## Merging data into one dataset
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
SmphSet <- rbind(mrg_train, mrg_test)

# Reading column names
colNames <- colnames(SmphSet)

## Create Mean and Standard Deviation vector & subset
meanStd <- (grepl("activityId" , colNames) | 
            grepl("subjectId" , colNames) | 
            grepl("mean.." , colNames) | 
            grepl("std.." , colNames) 
            )

dsmeanStd <- SmphSet[ ,meanStd == TRUE]


setactNames <- merge(dsmeanStd, activityLabels, by='activityId', all.x = TRUE)

## Using descriptive activity names to name the activities in the data set:
setActivityNames <- merge(setactNames, activityLabels,
                              by='activityId',
                              all.x=TRUE)

## Creating a second, independent tidy data set with the average of each variable for each activity and each subject:
## Making second tidy data set
sepTidySet <- aggregate(. ~subjectId + activityId, setActivityNames, mean)
sepTidySet <- sepTidySet[order(sepTidySet$subjectId, sepTidySet$activityId),]

## Writing second tidy data set in txt file
write.table(sepTidySet, "./Tidy_Data/sepTidySet.txt", row.name=FALSE)