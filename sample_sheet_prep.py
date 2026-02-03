# libraries
import pandas as pd
import sys
import os

# read in sample sheet
df = pd.read_csv(sys.argv[1])
#df.head

# data overview
print("Data preview of your sample sheet (please refer to README.md for more information):")
print('#=============================#')
print("Columns: ", df.columns.tolist())
print('#=============================#')
print("Describe data: ", df.describe)
print('#=============================#')
print("Dataset shape: ", df.shape)
print('#=============================#')
print("Missing values:\n",df.isnull().sum())
print('#=============================#')

# check for unexpected columns
expected_columns = {"sample","fastq_1","fastq_2","Platform", "LibraryLayout", "LongReads", "LongReadsPlatform", "Reference", "GenomeSize", "barcode", "ont_dir"}
unexpected_columns = set(df.columns) - expected_columns
if unexpected_columns:
	print("!!! Unexpected columns found !!!: ", unexpected_columns)
	print("Please remove or rename these columns before proceeding.")
else:
	print("All columns are valid")

print('#=============================#')

# check for duplicated sample names
duplicated_samples = df['sample'][df['sample'].duplicated()].unique()
if len(duplicated_samples) > 0:
	print("!!! Duplicated sample names found !!!: ", duplicated_samples)
	print("Please ensure all sample names are unique before proceeding.")
else:
	print("All sample names are unique")

#=========================================#
# user inputs edits
#=========================================#
print("You have the option to edit your samplesheet - a new copy will be saved as 'cleaned_<original_filename>'")
input("Press Enter to continue...")

# remove unnecessary columns
remove_cols = input("remove columns? y/n")
if remove_cols == "y":
	cols = input("Enter columns to remove (comma-separated if multiple): ")
	df = df.drop(columns=[cols.strip() for cols in cols.split(",")], axis=1)
else:
	print("No columns removed")

# rename columns
rename_cols = input("rename columns? y/n")
if rename_cols == "y":
	cols = input("Enter columns to rename in format old1:new1,old2:new2: ")
	rename_dict = {}
	for pair in cols.split(","):
		old, new = pair.split(":")
		rename_dict[old.strip()] = new.strip()
	df = df.rename(columns=rename_dict)
else:
	print("No columns renamed")

# add columns
add_cols = input("add columns? y/n")
if add_cols == "y":
	cols = input("Enter new columns in format col1:val1,col2:val2: ")
	for pair in cols.split(","):
		col, val = pair.split(":")
		df[col.strip()] = val.strip()
else:
	print("No columns added")
# fill missing values
fill_na = input("fill missing values? y/n")
if fill_na == "y":
	column = input("Enter column: ")
	value = input("Enter value to fill missing values with: ")
	df[column] = df[column].fillna(value)
else:
	print("No missing values filled")

# give list to fill missing values
fill_na_list = input("fill missing values from list? y/n")
if fill_na_list == "y":
	column = input("Enter column: ")
	values = input("Enter comma-separated list of values: ").split(",")
	values = [v.strip() for v in values]
	df[column] = df[column].fillna(pd.Series(values))
else:
	print("No missing values filled from list") 
# capitalize entries
capitalise = input("capitalise entries? y/n")
if capitalise == "y":
	column = input("Enter column: ")
	df[column] = df[column].astype(str).str.upper()
else:
	print("No changes made to capitalization")

# change suffixes/extensions 
extension = input("edit extension/suffix? y/n")
#prefix = input('change prefix? y/n')
if extension == "y":
	decision = input("change, remove or add extension? (c/r/a): ")
	column = input("Enter column: ")
	if decision == "a":
		ext = input("Enter extension to add: ")
		df[str(column)] = df[str(column)].apply(lambda x: x if not isinstance(x, str) or x.endswith(str(ext)) else x + str(ext) )
	elif decision == "r":
		ext = input("Enter extension to remove: ")
		df[column] = df[column].apply(lambda x: x[:-len(ext)] if isinstance(x, str) and x.endswith(ext) else x)
	elif decision == "c":
		ext = input("Enter current extension: ")
		new_ext = input("Enter new extension: ")
		df[column] = df[column].apply(lambda x: x[:-len(ext)] + new_ext if isinstance(x, str) and x.endswith(ext) else x)
else:
	print("No changes made to extensions")

saveas = os.path.basename(sys.argv[1])
df.to_csv(f'cleaned_{saveas}', index=False)
