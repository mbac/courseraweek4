# Coursera Week 4 Assignment Codebook

This file is meant to describe data manipulation steps in the assignment.

## Library requirements
This script requires package `readr` to access fixed-width files, `data.table` (which was chosen over `dplyr` for performance reason) and, optionally, `renv` to maintain optimal portability and reproducibility.
## Column labeling
Column names and labels for the `activity` factor were read in as columns in data frames from the relevant files, as specified in the data set documentation (also see below).
## Variable definitions
In the final data sets, variable are named as follows:
### Global data set (`data`)
- **`activity`** - factor indicating the kind of activity a subject was engaging in when measurements were taken.
- **`subjects`** - subject id
- all measurements in original data set
- The **`data`** data frame/data table is the result of the following
	- `read_table` from fixed-width formal text file (`X_train` and `X_test`)
	- application of column names as per original codebook in file `features.txt`, converted to lower case
	- column binding with data from files `y_` and `subject_`, containing a single column of data each (activity and subject id, respectively)
	- coercion of `activity` into a factor whose labels were taken from file `activity_labels.txt` as vector
	- Identical transformations were applied to the `*_test` data sets, which was then merged (row bound) to `data`.
### Mean, standard deviation data set (`meansd_data`)
- Columns names were extracted from `names(data)` whose name contained `mean()` or `sd()`, signifying that the presented values were average of each time period.
	- Variables `activity` and `subjects` were also kept for later use.
	- Regexp `"^.*(std\\(\\)|mean\\(\\)|activity|subjects)"` was used (please note the double escape char for R compatibility).
- A new data table was created with the above columns
### Subject- and activity-averaged data (`avg_data`)
- Data was grouped by `subjects` and then by `activity`
- The same function (`mean()`, as requested) was applied to each group and all columns except `activity` and `subjects`.
- The resulting data table shows 180 observations, which is compatible with 6 values (one for each activity type) for each of the 30 subjects.

# Variables

## `meansd_data` table
- Column 1:66 contain means and standard deviations for all variables measured from sensors.
- `activity`: factor (6 levels) indicating the type of activity the subject was engaging in when measurements were taken
- `subjects`: subject ID (a total of 30 were enrolled)
- Every row in the dataset records the mean/SD values of all measurements taken on every subject during each activity period.

## `avg_data` table
- Column 1:66 contain means and standard deviations for all variables contained in `meansd_data`; values have been grouped by `subjects` and then by `activity` type, and their means are reported. This results in 6 values for each of the 30 subjects.
- `activity`: same as `meansd_data` variable
- `subjects`: same as `meansd_data` variable

All variables are presented as `double`, normalized to [-1,+1], except for `activity` (character vector) and `subjects` (integer vector).
