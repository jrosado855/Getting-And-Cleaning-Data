# Download the file and put the file in the data folder
    if(!file.exists("./data")){dir.create("./data")}
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/Dataset.zip",method="auto")

# Unzip the file
    unzip(zipfile="./data/Dataset.zip",exdir="./data")

# unzipped files are in the folderUCI HAR Dataset. 
    path_rf <- file.path("./data" , "UCI HAR Dataset")
    files<-list.files(path_rf, recursive=TRUE)
    files

# Read data from the files into the variables
    dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
    dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
    dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
    dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
    dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
    dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

# Look at the properties of the above varibles
    str(dataActivityTest)
    str(dataActivityTrain)
    str(dataSubjectTrain)
    str(dataSubjectTest)
    str(dataFeaturesTest)
    str(dataFeaturesTrain)

# Question 1 - Merges the training and the test sets to create one data set
    dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
    dataActivity<- rbind(dataActivityTrain, dataActivityTest)
    dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

# set names to variables
    names(dataSubject)<-c("subject")
    names(dataActivity)<- c("activity")
    dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
    names(dataFeatures)<- dataFeaturesNames$V2

# Merge columns to get the data frame Data for all data
    dataCombine <- cbind(dataSubject, dataActivity)
    Data <- cbind(dataFeatures, dataCombine)


# Question 2 - Extracts only the measurements on the mean and standard deviation for each measurement
    
    subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

# Subset the data frame Data by seleted names of Features
    selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
    Data<-subset(Data,select=selectedNames)

# Check the structures of the data frame Data
    str(Data)

# Question 3 - Uses descriptive activity names to name the activities in the data set

    activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

# facorize Variale activity in the data frame Data using descriptive activity names
    head(Data$activity,30)

# Question 4 - Appropriately labels the data set with descriptive variable names
    names(Data)<-gsub("^t", "time", names(Data))
    names(Data)<-gsub("^f", "frequency", names(Data))
    names(Data)<-gsub("Acc", "Accelerometer", names(Data))
    names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
    names(Data)<-gsub("Mag", "Magnitude", names(Data))
    names(Data)<-gsub("BodyBody", "Body", names(Data))
    
    names(Data)

# Question 5 - Creates a second,independent tidy data set and ouput it
    library(plyr);
    Data2<-aggregate(. ~subject + activity, Data, mean)
    Data2<-Data2[order(Data2$subject,Data2$activity),]
    write.table(Data2, file = "tidydata.txt",row.name=FALSE)
        
