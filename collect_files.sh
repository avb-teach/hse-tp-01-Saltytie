#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
fi

input_dir="$1"
output_dir="$2"

# Check if input directory exists
if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory does not exist"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Find all files in input directory and its subdirectories
find "$input_dir" -type f | while read -r file; do
    # Get the base filename
    filename=$(basename "$file")
    
    # Generate a unique name if file already exists in output directory
    counter=1
    new_filename="$filename"
    while [ -e "$output_dir/$new_filename" ]; do
        new_filename="${filename%.*}_$counter.${filename##*.}"
        ((counter++))
    done
    
    # Copy the file to output directory
    cp "$file" "$output_dir/$new_filename"
done

echo "Files copied successfully from $input_dir to $output_dir"
