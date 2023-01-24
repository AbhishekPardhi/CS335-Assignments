#!/bin/bash

# NOTE: You must have (1) "lex.l" and the folder "result" (which should have all the testcases in it) in the same directory as this bash file.

lexer_name="lex_1.l" # Replace with the name of your lexer file
program_name="scan" # Replace with the name of your program
execute_program="./"$program_name
csv_name="_result.csv" # Replace with the name of your csv file
testcases_folder_path="./testcases" # Replace with the path to the folder containing the input files
result_folder_path="./result" # Replace with the path to the folder containing the result files

chmod +x build.sh # Adding execute permissions for script

if [ ! -d "$result_folder_path" ]; then
  mkdir $result_folder_path
fi

flex $lexer_name
g++ -o $program_name lex.yy.c -ll

for file in $testcases_folder_path/*; do
    echo "Running program with input from file: $file"
    result_path=$result_folder_path"/"$(basename $file)$csv_name
    $execute_program $result_path < $file
done