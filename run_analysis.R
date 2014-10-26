setwd("/Users/okada/myWork/coursera/getting_and_cleaning_data")
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_x  <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y  <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject  <- read.table("./UCI HAR Dataset/test/subject_test.txt")


dim(train_x);dim(train_y);dim(test_x);dim(test_y)
dim(train_subject); dim(test_subject)
# 7352 rows and 561 columns for training
# 2947 rows and 561 columns for testing

# 1. Merges the training and the test sets to create one data set.
# first, merge X and y variables. To avoid the variable name conflict, rename the 
# column name of y data
colnames(train_y)<-"activity_labels"; colnames(test_y) <- "activity_labels"
colnames(train_subject) <- "subject_id"; colnames(test_subject) <- "subject_id"
train <- cbind(train_x, train_y, train_subject)
testing <- cbind(test_x, test_y, test_subject)
# Add one column to tell if it is from training or test data set.
train$data_type <- "train"
testing$data_type <- "test"
# merge 
dat <- rbind(train, testing)
# check the number of columns and rows
dim(dat)
# 10299(=7352+2947) rows and 564(=561+1+2) columns 

########################################################
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# We need to extract variables whose names include "mean()" or "std()". grep function
# can return the column indices that match those names.
# First, we read the name of features.
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
# change the labels of columns
colnm <- colnames(dat)
colnm[1:561] <- features$V2
colnames(dat) <- colnm
head(dat)
# find indices of feature names that include mean or std
idx <- grep("(mean|std)", features$V2)
features$V2[idx]
dat1 <- dat[, c(idx, 562:564)]
dim(dat1)
# 82 columns

########################################################
## 3. Uses descriptive activity names to name the activities in the data set
# activity_labels.txt file contains the combination of labels and activity names.
# Read this file and merge the testing and training data with the master file.
activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_label) <- c("activity_labels","activity_name")
dat2 <- merge(dat1, activity_label, by=c("activity_labels"))
## check if the data are correctly merged
head(dat2[,c("activity_labels","activity_name")])
table(dat2[,c("activity_labels","activity_name")])
dim(dat2)
head(dat2[,1:10])


## 4. From the data set in step 3, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
library(plyr)
library(reshape2)
colnames(dat2)
dat.melt <- melt(dat2, id=c("subject_id","activity_name"), measure.vars=colnames(dat2)[2:80])
dim(dat.melt)
dat.final <- ddply(dat.melt, .(subject_id, activity_name, variable), 
                   summarize, value=mean(value, na.rm=TRUE))
dim(dat.final) # 14220 x 4 data frame
# check if we have the right number of rows
length(unique(dat2$subject_id)) # 30 subjects
length(unique(dat2$activity_name)) # 6 activities
length(colnames(dat2)[2:80]) # 79 features
# so we should have 30 x 6 x 79 rows, which is 14220 as below.
30*6*79 # 14220

# output the final tiny data set
write.table(dat.final, file="./assignment_tiny_dataset.txt", row.name=FALSE)
