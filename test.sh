#!/bin/bash

# Define the exec files and tests folder
EXEC_UNDER_TEST="../part2"
TESTS_FOLDER="tests"
FOLDER_TESTER="tester_outputs"
FOLDER_PROG="prog_outputs"

# Create directories for outputs (delete if they exist)
if [ -d "$FOLDER_PROG" ]; then
    rm -r "$FOLDER_PROG"
fi
mkdir "$FOLDER_PROG"

# Loop through all .cmm files in the tests folder
for test_file in "$TESTS_FOLDER"/*.cmm; do
    test_name=$(basename "$test_file" .cmm)
    # Run the prog exec and save the output
    ./$EXEC_UNDER_TEST < "$test_file" > "$FOLDER_PROG/$test_name.out"
done

# Compare the outputs and report mismatches
for tester_out in "$FOLDER_TESTER"/*.out; do
    test_name=$(basename "$tester_out" .out)
    prog_out="$FOLDER_PROG/$test_name.out"

    if ! diff -q "$tester_out" "$prog_out" > /dev/null; then
        echo "Mismatch found for test: $test_name"
    fi
done