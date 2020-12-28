
# This script manipulates accelerometric data from the Coursera Data Science
# Specialization Week 4 assignment (Getting and Cleaning Data)

# Specify name of data directory within working directory
DATA_DIRECTORY <- "data"

# Load required packages. renv is used to maintain reproducibility
library(renv)
suppressMessages(
    renv::activate()
)
# Also using data.table for fast table operations at beginning of script
library(data.table)
library(readr)
library(tidyverse)
# Load special function(s) for this script
source("week4lib.R")


# The folder structure in the example dataset is quite complicated. This script
# assumes all relevant data have been moved to a .data/ subdir of the working
# directory and that original file names have been preserved.

# Read in labels for activity IDs
activity_labels <-
    read_table('data/activity_labels.txt', col_names = FALSE, col_types = cols())
# Read in variable names from 'legend' file. Note that this file has more than
# one space between the two columns, so this less-strict function from package
# readr is preferable. col_types argument is to mute warnings, as per help file.
variable_names <-
    read_table2('data/features.txt', col_names = FALSE, col_types = cols())

# Load training data
data <- setDT(loadData("train"))
# And test data
test_data <- setDT(loadData("test"))

# Merge (row bind) the data sets. For performance, we keep one of the DTs
data <- rbind(data, test_data)

# Extract variables containing mean/standard deviation of measurements. These
# are identified by -mean() or -std(), according to the codebook. Use grep() to
# create a variable which returns the indices of matches to select the columns
# similar to normal data frame. Remember to escape the escape char for this to
# work.
# We're also interested in keeping activity data?
meansd_names <- grep("^.*(std\\(\\)|mean\\(\\)|activity|subjects)",
                       names(data))

# Extract columns. Since we're referring to a variable defined in the calling
# environment (not a column name from the data.table) we need to use the
# "dot-dot" notation in data.table. We'll call this meansd_train.
meansd_data <- data[, ..meansd_names]

# Create a new data.table showing averaged data by subject and activity
avg_data <-
    meansd_data[,
                # Apply mean to all selected columns
                lapply(.SD, mean),
                # Selecting everything except these 2 (minus sign)
                .SDcols = -c("activity", "subjects"),
                # Group data by subject and activity, as requested
                by = .(subjects, activity)
                ]


