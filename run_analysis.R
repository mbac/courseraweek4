
# This script manipulates accelerometric data from the Coursera Data Science
# Specialization Week 4 assignment (Getting and Cleaning Data)

# Specify name of data directory within working directory
DATA_DIRECTORY <- "data"

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
activity_labels <-
    read_table('data/activity_labels.txt', col_names = FALSE)
# Read in variable names from 'legend' file. Note that this file has more than
# one space between the two columns, so this less-strict function from package
# readr is preferable
variable_names <-
    read_table2('data/features.txt', col_names = FALSE)

# Set the name of the directory containing data and prepare file path
data_dir <- file.path(getwd(), DATA_DIRECTORY)

# We then define a function which takes a string as argument, builds file names
# from it, reads in data and sets it up for further evaluation.

loadData <- function(suffix, extension = 'txt') {

    if ((!is.character(suffix)) | (suffix == ""))
        # Throw a fit
        stop("Invalid argument; must be a string prefix for file names")

    # Common path/filename for all data files
    base_datafile <- file.path(
        data_dir,
        paste0("X_", suffix, ".", extension)
        )

    base_activityfile <- file.path(
        data_dir,
        # Add file extension
        paste0("y_", suffix, ".", extension)
    )

    # Load training data set, by pasting the generic file names and the suffix, supplied
    # as argument.

    data <- read_table(base_datafile, col_names = FALSE)
    # a separate file contains the activity ID variable
    activity <- read_table(base_activityfile, col_names = FALSE)

    # Convert large tibbles/dfs to data.table's for faster operation
    setDT(data)
    setDT(activity)

    # Apply variable names to the main data set. Make sure you refer to the column
    # contents… Also note that we've added a variable at the beginning: activity.
    # This has to be labeled manually.

    # Var names are to be set to lowercase for better looks
    names(data) <- str_to_lower(variable_names[[2]])

    # Combine DTs: add activity IDs's to the data
    data[, activity := ..activity[[1]]]

    # activity type should be a factor. Its labels are stored in the label variable.
    # Again using data.table approach for possibly faster computing.
    data[, activity := factor(activity, labels = activity_labels[[2]])]

    # return data by reference (AFAIK)
    data

}

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
meansd_names <- grep("^.+-(std\\(\\)|mean\\(\\))",
                names(data)
                )

# Extract columns. Since we're referring to a variable defined in the calling
# environment (not a column name from the data.table) we need to use the
# "dot-dot" notation in data.table. We'll call this meansd_train.
meansd_train <- data[, ..meansd_names]


