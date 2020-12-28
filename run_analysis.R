
# This script manipulates accelerometric data from the Coursera Data Science
# Specialization Week 4 assignment (Getting and Cleaning Data)

# Load required packages. renv is used to maintain reproducibility
library(renv)
# Also using data.table for fast table operations at beginning of script
library(data.table)
library(readr)
library(tidyverse)

# The folder structure in the example dataset is quite complicated. This script
# assumes all relevant data have been moved to a .data/ subdir of the working
# directory and that original file names have been preserved.

# Load training data set:
train_data <- read_table('data/X_train.txt', col_names = FALSE)
# a separate file contains the subject ID variable
train_subj <- read_table('data/y_train.txt', col_names = FALSE)

# Blah blaj

# Convert tibbles/dfs to data.table's for faster operation
train_data <- setDT(train_data)
train_subj <- setDT(train_subj)

train <- cbind(train_subj, train_data)
