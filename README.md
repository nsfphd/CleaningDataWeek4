# Cleaning Data Project Description

From the original assignment:

<ol>
<li>Merges the training and the test sets to create one data set.</li>
<li>Extracts only the measurements on the mean and standard deviation for each measurement.</li>
<li>Uses descriptive activity names to name the activities in the data set</li>
<li>Appropriately labels the data set with descriptive variable names.</li>
<li>From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.</li>
</ol>

Step 1 required multiple steps.  After importing the X_ axis datasets (most of the variables)
I used cbind to add the activity codes before combining the two using rbind.  This preserved the order 
of the original datasets for proper X and Y append.  

Step 4 was simple.  The labels for the variables were extracted 
as a separate vector and then used to create the column names. This was done before Step 2 
to make the removal of all non-mean/non-std variables simple.

Step 2 uses grep with a regex pattern to identify the needed columns and discard the rest.
The regex pattern identifies the variables that end with "mean()", "std(), or "code".  The 
first two id the columns specified in the assignment, while the third is the column containing
the data from the Y_ axis for the activity code.

Step 3 uses the data from the Y labels description file, imported as a data frame/
lookup table, to translate the numeric code to a descriptive text file

Step 5 uses dplyr methods to pipe the variables, grouped by the activity, and then 
generate the means for every variable across each activity.  The summarize_all method 
made this extremely simple.  The resulting dataset is written to a txt file.

Noelle Foster
Submitted 8/5/2017