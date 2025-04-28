#!/bin/bash

max_depth=""
input_dir=""
output_dir=""

if [ "$1" = "--max_depth" ]; then
    if [ $# -ne 4 ]; then
        echo "Использование: $0 [--max_depth N] ВХОДНАЯ_ДИРЕКТОРИЯ ВЫХОДНАЯ_ДИРЕКТОРИЯ"
        exit 1
    fi
    max_depth="$2"
    input_dir="$3"
    output_dir="$4"
else
    if [ $# -ne 2 ]; then
        echo "Использование: $0 [--max_depth N] ВХОДНАЯ_ДИРЕКТОРИЯ ВЫХОДНАЯ_ДИРЕКТОРИЯ"
        exit 1
    fi
    input_dir="$1"
    output_dir="$2"
fi


if [ ! -d "$input_dir" ]; then
    echo "Входная директория не существует: $input_dir"
    exit 1
fi

mkdir -p "$output_dir"

if [ -n "$max_depth" ]; then
    if ! [[ "$max_depth" =~ ^[0-9]+$ ]]; then
        echo "Ошибка: --max_depth должен быть положительным целым числом."
        exit 1
    fi
    find_maxdepth=$((max_depth + 1))
else
    find_maxdepth=""
fi

while IFS= read -r -d '' src_path; do
    filename=$(basename "$src_path")
    name="${filename%.*}"
    ext="${filename##*.}"

  
    if [ "$name" = "$filename" ]; then
        ext=""
    fi

    dest_name="$filename"
    counter=1

   
    while [ -e "$output_dir/$dest_name" ]; do
        if [ -z "$ext" ]; then
            dest_name="${name}_${counter}"
        else
            dest_name="${name}_${counter}.${ext}"
        fi
        counter=$((counter + 1))
    done


    cp "$src_path" "$output_dir/$dest_name"
done < <(
    if [ -n "$find_maxdepth" ]; then
        find "$input_dir" -type f -maxdepth "$find_maxdepth" -print0
    else
        find "$input_dir" -type f -print0
    fi
)

echo "Файлы успешно скопированы в $output_dir"
