#!/bin/bash
chmod +x collect_files.sh

if [ $# -ne 2 ]; then
    echo "Использование: $0 ВХОДНАЯ_ДИРЕКТОРИЯ ВЫХОДНАЯ_ДИРЕКТОРИЯ"
    exit 1
fi

input_dir="$1"
output_dir="$2"


if [ ! -d "$input_dir" ]; then
    echo "Ошибка: Входная директория не существует: $input_dir"
    exit 1
fi


mkdir -p "$output_dir"


find "$input_dir" -type f -print0 | while IFS= read -r -d '' file; do
 
    filename=$(basename -- "$file")
    
    
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
        ((counter++))
    done
    
   
    cp -- "$file" "$output_dir/$dest_name"
done

echo "Файлы успешно скопированы в $output_dir"
