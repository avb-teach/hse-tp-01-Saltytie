#!/bin/bash
max_depth=0
input_dir=""
output_dir=""

if [[ "$1" == "--max_depth" ]]; then
    if [[ $# -ne 4 ]]; then
        echo "Usage: $0 [--max_depth <depth>] <input_dir> <output_dir>"
        exit 1
    fi
    max_depth="$2"
    input_dir="$3"
    output_dir="$4"
else
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 [--max_depth <depth>] <input_dir> <output_dir>"
        exit 1
    fi
    input_dir="$1"
    output_dir="$2"
fi

if [[ ! -d "$input_dir" ]]; then
    echo "Input directory does not exist: $input_dir"
    exit 1
fi

mkdir -p "$output_dir"

find_args=("$input_dir" -type f)
if [[ $max_depth -gt 0 ]]; then
    find_args+=(-maxdepth "$max_depth")
fi

find "${find_args[@]}" -print0 | while IFS= read -r -d '' file; do
    base_name=$(basename -- "$file")
    dest="$output_dir/$base_name"
    name_part="${base_name%.*}"
    extension_part="${base_name##*.}"
    if [[ "$name_part" == "$extension_part" ]]; then
        extension_part=""
    else
        extension_part=".$extension_part"
    fi

    counter=1
    while [[ -e "$dest" ]]; do
        if [[ -n "$extension_part" ]]; then
            dest="$output_dir/${name_part}_${counter}.${extension_part#.}"
        else
            dest="$output_dir/${name_part}_${counter}"
        fi
        ((counter++))
    done
    cp -- "$file" "$dest"
done

exit 0
