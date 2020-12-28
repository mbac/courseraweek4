# courseraweek4
## Assignment for Week 4
This repo contains two files. The main script, `run_analysis.R` is the actual script to run to get and clean data as per assignment requests. It sources file `week4lib.R`, which needs to be in the working directory and defines the main function which loads and prepares data in a programmatic fashion, according to user input.
## How to use
- Import data files:
	- activity_labels.txt
	- features.txt
	- subject_*.txt*_
	- X_*_
	- y_*_
	- Note that these are the original file names and the scripts expect them.
- Place files into a data directory of your choice within the scripts working directory (indicated by `get_wd()`)
- Specify directory name by assigning it to the `DATA_DIRECTORY` variable in `run_analysis.R`. Default is `data`.
- Start the procedure