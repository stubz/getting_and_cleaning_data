# Getting and Cleaning Data : Course Project

## How the script works
The script has three parts. 
1. Reading the training and testing data, and merge them 
2. Transforming the merged data ( labelling column names and extract necessary columns)
3. Calculating the average values by subject and activity name

###Reading the training and testing data
The first part reads all the data sets. We have three files for each of the training and the testing data set; i.e. features, the activity label and subject ID. These three files are read by read.table function, then they are merged by cbind function. 
```
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_x  <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y  <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject  <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train <- cbind(train_x, train_y, train_subject)
testing <- cbind(test_x, test_y, test_subject)
```
The training and testing data are finally merged by rbind function to make one data set.
```
dat <- rbind(train, testing)
```

### Transforming the merged data
Both the training and testing data do not have the header names. read.table() function automatically creates column names, such as V1 and V2. feature.txt file includes the feature name, and we merge this file with the data set we created in the first step. 
We need to extract only the measurements on the mean and standard deviation. Some feature names show "mean()" or "std()", so we can use grep function to find which columns are the measurements on the mean and standard deviation. 
```
# read features names
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
# find indices of feature names that include mean or std
idx <- grep("(mean|std)", features$V2)
```
There are 79 variables that include either mean or std in its variable name.
The activity label show numbers from 1 to 6, and activity_labels.txt file tells us which number corresponds to which activity. The file is merged by merge function, and the final data set shows the activity names as well as the activity labels.
```
activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_label) <- c("activity_labels","activity_name")
dat <- merge(dat, activity_label, by=c("activity_labels"))
```

### Calculating the average values by subject and activity name
Finally, we need to calculate the average values by subject and activity name. plyr and reshape2 libaries are used here. melt function of reshape2 library is first applied so that we have a normalised data set where each record has value for a subject, activity_name and one feature. 
```
dat.melt <- melt(dat, id=c("subject_id","activity_name"), measure.vars=colnames(dat)[2:80])
```
This makes it a lot easier to calculate the average by subject and activity name. Then dplyr function of plyr library is used to get the average.
```
dat.final <- ddply(dat.melt, .(subject_id, activity_name, variable), 
                   summarize, value=mean(value, na.rm=TRUE))
```
As a sanity check, the number of rows of the final tiny data set is calculated to see if it has the right number of rows. Since there are 6 activities, 30 subjects and 79 features on the mean and standard deviation, we should have 6 times 30 times 79 rows, that is 14220. dim function returns the number of rows and columns of the final data set, and the number of rows is 14220. 

