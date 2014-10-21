TidyActivity
============

Course project for "Getting and Cleaning Data" on Coursera

The raw data are obtained and processed to tidy data which are outputted to 
tidyData.txt, all by the R script run_analysis.R.  The output and can be read 
and viewed in R with:

```{r}
readData <- read.table("tidyData.txt", header = TRUE)
View(readData)
```
run_analysis.R uses the dplyr and tidyr packages to do the following:

- Downloads the raw data
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each 
        measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately label the data set (features) with descriptive variable names. 
- From the data set above, creates a second, independent tidy data set
      with the average of each variable for each activity and each subject. 
      This is done searching the variable names containing "mean" and "std" 
      (not case sensitive) using grepl. The sample averages are calculated
      per activity and per individual using the "group_by" and "summarize_each" 
      functions of dplyr.
- The new tidy data are saved as tidyData.txt
    