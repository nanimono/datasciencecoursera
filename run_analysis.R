# install.packages("data.table");
library(dplyr);

# Merges the training and the test sets to create one data set.
dat_location <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
download.file(dat_location, destfile = "data.zip", method = "curl");
unzip("data.zip");
list.files("UCI HAR Dataset/test"); # check file names

data_feature <- read.table("UCI HAR Dataset/features.txt", header=FALSE);
data_activity_label <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE);
data_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE);
data_train_label <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE);
data_train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE);
data_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE);
data_test_label <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE);
data_test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE);

# Appropriately labels the data set with descriptive variable names. 
# Uses descriptive activity names to name the activities in the data set
label_category <- c("Activity", "Subject");
data_train_label[[1]] <- factor(data_train_label[[1]], levels = data_activity_label[[1]], labels = data_activity_label[[2]]);
data_test_label[[1]] <- factor(data_test_label[[1]], levels = data_activity_label[[1]], labels = data_activity_label[[2]]);
colnames(data_train) <- data_feature[[2]];
colnames(data_test) <- data_feature[[2]];
colnames(data_train_label) <- label_category[1];
colnames(data_test_label) <- label_category[1];
colnames(data_train_subject) <- label_category[2];
colnames(data_test_subject)<- label_category[2];
data_final <- rbind(cbind(data_train, data_train_label, data_train_subject), cbind(data_test, data_test_label, data_test_subject));

# Extracts only the measurements on the mean and standard deviation for each measurement. 
data_final_mean <- unlist(lapply(data_final[, (names(data_final) %in% c("Activity", "Subject")) == FALSE ], mean, na.rm=TRUE));
data_final_sd <- unlist(lapply(data_final[, (names(data_final) %in% c("Activity", "Subject")) == FALSE ] , sd, na.rm=TRUE));

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table);
output <- data.table(data_final);
data_cleaned <- output[ , lapply( .SD, function(x) mean(x)) , by = "Activity,Subject" ];
write.csv(data_cleaned,　file="data_final_cleaned.csv", row.names = FALSE);

