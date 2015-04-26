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


