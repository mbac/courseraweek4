# We define a function which takes a string as argument, builds file names
# from it, reads in data and sets it up for further evaluation.

loadData <- function(suffix, extension = 'txt') {

    if ((!is.character(suffix)) | (suffix == ""))
        # Throw a fit
        stop("Invalid argument; must be a string prefix for file names")

    # Set the name of the directory containing data and prepare file path
    data_dir <- file.path(getwd(), DATA_DIRECTORY)

    # Common path/filename for all data files: measurements, activity type,
    # subject id
    base_datafile <- file.path(
        data_dir,
        paste0("X_", suffix, ".", extension)
    )

    base_activityfile <- file.path(
        data_dir,
        # Add file extension
        paste0("y_", suffix, ".", extension)
    )

    base_subjectfile <- file.path(
        data_dir,
        # Add file extension
        paste0("subject_", suffix, ".", extension)
    )

    # Load training data set, by pasting the generic file names and the suffix, supplied
    # as argument.

    data <-
        read_table(base_datafile, col_names = FALSE, col_types = cols())
    # a separate file contains the activity ID variable
    activity <-
        read_table(base_activityfile,
                   col_names = FALSE,
                   col_types = cols())
    # Subject IDs
    subjects <-
        read_table(base_subjectfile,
                   col_names = FALSE,
                   col_types = cols())

    # Convert large tibbles/dfs to data.table's for faster operation
    setDT(data)
    setDT(activity)
    setDT(subjects)

    # Apply variable names to the main data set. Make sure you refer to the column
    # contents… Also note that we've added a variable at the beginning: activity.
    # This has to be labeled manually.

    # Var names are to be set to lowercase for better looks
    names(data) <- str_to_lower(variable_names[[2]])

    # Combine DTs: add activity IDs's to the data
    data[, activity := ..activity[[1]]]
    data[, subjects := ..subjects[[1]]]

    # activity type should be a factor. Its labels are stored in the label variable.
    # Again using data.table approach for possibly faster computing.
    data[, activity := factor(activity, labels = activity_labels[[2]])]

    # return data by reference (AFAIK)
    data

}
