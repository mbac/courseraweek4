
# This script manipulates accelerometric data from the Coursera Data Science
# Specialization Week 4 assignment (Getting and Cleaning Data)

# Load required packages. renv is used to maintain reproducibility
library(renv)
renv::activate()
# Also using data.table for fast table operations at beginning of script
library(data.table)
library(readr)
library(tidyverse)

# The folder structure in the example dataset is quite complicated. This script
# assumes all relevant data have been moved to a .data/ subdir of the working
# directory and that original file names have been preserved.

# Read in labels for activity IDs
activity_labels <- read_table('data/activity_labels.txt', col_names = FALSE)
# Read in variable names from 'legend' file. Note that this file has more than
# one space between the two columns, so this less-strict function from package
# readr is preferable
variable_names <- read_table2('data/features.txt', col_names = FALSE)

# Load training data set:
train_data <- read_table('data/X_train.txt', col_names = FALSE)
# a separate file contains the activity ID variable
train_activity <- read_table('data/y_train.txt', col_names = FALSE)

# Convert large tibbles/dfs to data.table's for faster operation
setDT(train_data)
setDT(train_activity)

# Apply variable names to the main data set. Make sure you refer to the column
# contents… Also note that we've added a variable at the beginning: activity.
# This has to be labeled manually.

# Var names are to be set to lowercase for better looks
names(train_data) <- str_to_lower(variable_names[[2]])

# Extract variables containing mean/standard deviation of measurements. These
# are identified by -mean() or -std(), according to the codebook. Use grep() to
# create a variable which returns the indices of matches to select the columns
# similar to normal data frame. Remember to escape the escape char for this to
# work.
meansd_names <- grep("^.+-(std\\(\\)|mean\\(\\))",
                names(train_data)
                )

# Extract columns. Since we're referring to a 'system' variable (not a column
# name from the data.table) we need to use the "dot-dot" notation in data.table.
# We'll call this meansd_train.
meansd_train <- train_data[, ..meansd_names]

# Combine DTs: add activity IDs's to the data
meansd_train[, activity := ..train_activity[[1]]]

# activity type should be a factor. Its labels are stored in the label variable.
# Again using data.table approach for possibly faster computing.
meansd_train[, activity := factor(activity, labels = activity_labels[[2]])]
