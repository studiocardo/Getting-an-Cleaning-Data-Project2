#
# Step 1:  Merge the training and test sets to create one data set
#


orgwd<-getwd()
wd<-file.path(orgwd, "train", sep="/")
setwd(wd)

x_train_df <- read.table("X_train.txt")
y_train_df <- read.table("y_train.txt")
subject_train_df <- read.table("subject_train.txt")

wd<-file.path(orgwd, "test", sep="/")
setwd(wd)

x_test_df <- read.table("X_test.txt")
y_test_df <- read.table("y_test.txt")
subject_test_df <- read.table("subject_test.txt")

#
# use rbin to combine {x,y,subject}_train.txt w/  {x,y,subject}_test.txt, respectively 
#
x_data_df <- rbind(x_train_df, x_test_df)

y_data_df <- rbind(y_train_df, y_test_df)

subject_data_df <- rbind(subject_train_df, subject_test_df)

#
# set the working directory to original level
#
setwd(orgwd)

#
# Step 2: Extract only the measurements on the mean and standard deviation for each measurement
#

features <- read.table("features.txt")

# get only columns with mean() or std() in their names
wanted <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data_df <- x_data_df[, wanted]

# correct the column names
names(x_data_df) <- features[wanted, 2]

#
# Step 3: Use descriptive activity names to name the activities in the data set
#

activities <- read.table("activity_labels.txt")

# replace index with actual activity names in y_xxx
#
y_data_df[, 1] <- activities[y_data_df[, 1], 2]

# Update the column name
#
names(y_data_df) <- "activity"

#
# Step 4: Appropriately label the data set with descriptive variable names
#

# correct column name
names(subject_data_df) <- "subject"

# bind all the data in a single data set
combined <- cbind(x_data_df, y_data_df, subject_data_df)

#
# Step 5: From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
#

# so we want to subset the data frame combined by each activity and subject and then compute the 
# means and then recombine them back into a data frame before I print it out
#

# probably best to use a library
# gonna use ddply function in the plyr library

library(plyr)


# 66 <- 68 columns but last two (activity & subject)
#
tidy_averages <- ddply(combined, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy_averages, "tidy_averages.txt", row.name=FALSE)



