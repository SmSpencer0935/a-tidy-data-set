# Create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the... 
#    average of each variable for each activity and each subject.


# Merge the training and the test sets to create one data set.

library(plyr)
library(data.table)
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)

subjectTest = read.table('./test/subject_test.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)

xDataSet <- rbind(xTrain, xTest)
yDataSet <- rbind(yTrain, yTest)
subjectDataSet <- rbind(subjectTrain, subjectTest)


# Extract only the measurements on the mean and standard deviation for each measurement.

xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xDataSet_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 

# Use descriptive activity names to name the activities in the data set.

yDataSet[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
names(yDataSet) <- "Activity"

# Appropriately label the data set with descriptive activity names.

names(subjectDataSet) <- "Subject"

singleDataSet <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)

names(singleDataSet) <- make.names(names(singleDataSet))
  names(singleDataSet) <- gsub('Acc',"Acceleration",names(singleDataSet))
  names(singleDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(singleDataSet))
  names(singleDataSet) <- gsub('Gyro',"AngularSpeed",names(singleDataSet))
  names(singleDataSet) <- gsub('Mag',"Magnitude",names(singleDataSet))
  names(singleDataSet) <- gsub('^t',"TimeDomain.",names(singleDataSet))
  names(singleDataSet) <- gsub('^f',"FrequencyDomain.",names(singleDataSet))
  names(singleDataSet) <- gsub('\\.mean',".Mean",names(singleDataSet))
  names(singleDataSet) <- gsub('\\.std',".StandardDeviation",names(singleDataSet))
  names(singleDataSet) <- gsub('Freq\\.',"Frequency.",names(singleDataSet))
  names(singleDataSet) <- gsub('Freq$',"Frequency",names(singleDataSet))

# Creates a second,independent tidy data set with the... 
# average of each variable for each activity and each subject.

DataNew<-aggregate(. ~Subject + Activity, singleDataSet, mean)
DataNew<-DataNew[order(DataNew$Subject,DataNew$Activity),]
write.table(DataNew, file = "TidyData.txt",row.name=FALSE)

