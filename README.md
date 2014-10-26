# Getting and Cleaning Data : Course Project

## How the script works
The script has three parts. 
1. Reading the training and testing data, and merge them 
2. Transforming the merged data ( labelling column names and extract necessary columns)
3. Calculating the average values by subject and activity name

###Reading the training and testing data
The first part reads all the data sets. We have three files for each of the training and the testing data set; i.e. features, the activity label and subject ID. These three files are read by read.table function, then they are merged by cbind function. The training and testing data are finally merged by rbind function to make one data set.

### Transforming the merged data
Both the training and testing data do not have the header names. read.table() function automatically creates column names, such as V1 and V2. feature.txt file includes the feature name, and we merge this file with the data set we created in the first step. 
We need to extract only the measurements on the mean and standard deviation. Some feature names show "mean()" or "std()", so we can use grep function to find which columns are the measurements on the mean and standard deviation. There are 79 variables that include either mean() or std() in its variable name.
The activity label show numbers from 1 to 6, and activity_labels.txt file tells us which number corresponds to which activity. The file is merged by merge function, and the final data set shows the activity names as well as the activity labels.

### Calculating the average values by subject and activity name
Finally, we need to calculate the average values by subject and activity name. plyr and reshape2 libaries are used here. melt function of reshape2 library is first applied so that we have a normalised data set where each record has value for a subject, activity_name and one feature. This makes it a lot easier to calculate the average by subject and activity name. Then dplyr function of plyr library is used to get the average. As a sanity check, the number of rows of the final tiny data set is calculated to see if it has the right number of rows. Since there are 6 activities, 30 subjects and 79 features on the mean and standard deviation, we should have 6 times 30 times 79 rows, that is 14220. dim function returns the number of rows and columns of the final data set, and the number of rows is 14220. 

