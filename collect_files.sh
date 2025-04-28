#!/bin/bash
chmod +x collect_files.sh


inputdir="$1"
outputdir="$2"

mkdir -p "$outputdir"

find "$inputdir" -type f -print0 | while IFS= read -r -d '' file; do
    filename="$(basename "$file")"
    base="${filename%.*}"
    ext="${filename##*.}"

    if [[ "$base" == "$filename" ]]; then
        ext=""
    else
        ext=".$ext"
    fi

    dest="$filename"
    index=1

    while [[ -e "$outputdir/$dest" ]]; do
        dest="${base}${index}${ext}"
        ((index++))
    done

    cp "$file" "$outputdir/$dest"
done

