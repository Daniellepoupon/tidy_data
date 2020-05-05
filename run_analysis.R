## LOad test & Train Data from file

getData<-function(url){
        
        myData<-read.table(url, header = FALSE)
        return(myData)
}

##Read files
activityNames<-getData("D:/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
rawTrainData<-getData("D:/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
rawTestData<-getData("D:/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
testLabels<-getData("D:/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
trainLabels<-getData("D:/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
headers<-getData("D:/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")



##Combine test & train Data
totalData<-rbind(rawTestData, rawTrainData)


#Rename headers

names(totalData)<-headers$V2

#Extract Mean & Standard Deviation Columns
stdPos<-grep("std()", headerList)
meanPos<-grep("mean()", headerList)
meanAndStdHeaders<-headerList[sort(c(stdPos,meanPos))]
subData<-totalData[, meanAndStdHeaders]


##Add Activity Labels to data
testLabelActivity<-merge(testLabels, activityNames, sort=FALSE)
trainLabelActivity<-merge(trainLabels, activityNames, sort=FALSE)
totalLabelActivity<-rbind(testLabelActivity,trainLabelActivity)
subData2<- subData %>% mutate(ActivityType= totalLabelActivity$V2)

##Summarize data by activity type
dataByActivity<-subData2 %>% group_by(ActivityType)
meanByActivity<-dataByActivity %>% summarise_all(funs(mean))


