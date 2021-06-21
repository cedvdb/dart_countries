

This package generates dart const from various data sources

The package is organized as such:

 - resources: the files responsible for generating the const files
 - src contain the models and const files

# Resource

to generate the files the following command can be used from the root of the project

for generating dart files (from root dir)

`dart resources/generate_country_data_files.dart && dart format .`

