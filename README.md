# courseraweek4
## Assignment for Week 4
This repo contains two files. The main script, `run_analysis.R` is the actual script to run to get and clean data as per assignment requests. It sources file `week4lib.R`, which needs to be in the working directory and defines the main function which loads and prepares data in a programmatic fashion, according to user input.
## How to use
- Import data files:
	- `activity_labels.txt`
	- `features.txt`
	- `subject_*.txt`
	- `X_*.txt`
	- `y_*.txt`
	- Note that these are the original file names and the scripts expect them.
- Place files into a data directory of your choice within the scripts working directory (indicated by `get_wd()`)
- Specify directory name by assigning it to the `DATA_DIRECTORY` variable in `run_analysis.R`. Default is `data`.
- Specify the file name suffix for the different data files. Default is `train` and `test` as found in the present data set. Could theoretically accomodate for further data sets from the same study.
- Start the procedure by running/sourcing `run_analysis.R`
- The results are data frame/data tables with different characteristics, as requested from the assignment: `data`, `meansd_data` and `avg_data`.  Please see [CodeBook.md](./CodeBook.md) for more information.
