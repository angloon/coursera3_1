library(dplyr)
library(sqldf)

#download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","../data/smartphone_raw.zip")
#unzip(zipfile = "../data/smartphone_raw.zip")

# Read relevant files
activity_labels=read.table("../data/UCI HAR Dataset/activity_labels.txt")
features=read.table("../data/UCI HAR Dataset/features.txt")
xtrain=read.table("../data/UCI HAR Dataset/train/X_train.txt")
ytrain=read.table("../data/UCI HAR Dataset/train/y_train.txt")
subject_train=read.table("../data/UCI HAR Dataset/train/subject_train.txt")
xtest=read.table("../data/UCI HAR Dataset/test/X_test.txt")
ytest=read.table("../data/UCI HAR Dataset/test/y_test.txt")
subject_test=read.table("../data/UCI HAR Dataset/test/subject_test.txt")


# Task 3 - Get activity names from ytest code
activity_test=sqldf("SELECT * from ytest,activity_labels where ytest.V1=activity_labels.V1")
activity_train=sqldf("SELECT * from ytrain,activity_labels where ytrain.V1 = activity_labels.V1")


# Task 4 - Label with meaningful column names
colnames(xtrain)=features[,2]
colnames(xtest)=features[,2]
colnames(subject_train)="subject"
colnames(subject_test)="subject"
colnames(activity_train)=c("act_id","act_id2","activity")
colnames(activity_test)=c("act_id","act_id2","activity")

# column bind to join the data from the 3 sources
train_data = cbind(xtrain,subject_train,activity_train)
test_data = cbind(xtest,subject_test,activity_test)

# Task 1 - Merges the training and the test sets to create one data set.
# Create combined dataset
combined_data = rbind(train_data,test_data)

# Task 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
# Extract only columns with "mean(" or "std(" in them, and "activity" and "subject". 
filtered_data= combined_data [, grepl("mean\\(|std\\(|activity|subject",names(combined_data)) ]

# Task 3 - Extracts only the measurements on the mean and standard deviation for each measurement. 
# Refer above, line 18 on. Uses descriptive activity names to name the activities in the data set

# Task 4 - Appropriately labels the data set with descriptive variable names. 
# Refer above, line 22 on. 

# Task 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

group_dataset=group_by(tbl_df(filtered_data),activity,subject)
group_average= summarise_each(group_dataset,funs(mean))

write.table(group_average,"tidy.txt")




