#!/bin/bash

# collectfiles.sh  ти
# Скрипт копирует все файлы из входной директории и вложенных папок в выходную директорию без структуры папок
# При совпадении имён файлов добавляет числовой суффикс
# Опционально поддерживается параметр --maxdepth N (глубина обхода)
#
# Использование:
# ./collectfiles.sh /path/to/inputdir /path/to/outputdir [--maxdepth N]

set -e

if [ $# -lt 2 ]; then
  echo "Usage: $0 inputdir outputdir --max_depth N"
  exit 1
fi

INPUTDIR="$1"
OUTPUTDIR="$2"
shift 2

MAXDEPTH=

while [[ $# -gt 0 ]]; do
  case "$1" in
    --maxdepth)
       shift
       MAXDEPTH="$1"
       if ! [[ "$MAXDEPTH" =~ ^0-9+$ ]]; then
          echo "Error: --maxdepth requires a positive integer"
          exit 1
       fi
       shift
       ;;
    *)
       echo "Unknown parameter: $1"
       exit 1
       ;;
  esac
done

if [[ ! -d "$INPUTDIR" ]]; then
  echo "Input directory does not exist: $INPUTDIR"
  exit 1
fi

mkdir -p "$OUTPUTDIR"

declare -A filecounts

# Функция для копирования файла с суффиксом при совпадении имени
copywithsuffix () {
  local src="$1"
  local base=$(basename "$src")
  local name="${base%.*}"
  local ext="${base##*.}"
  if [[ "$ext" == "$base" ]]; then
    ext=""
  else
    ext=".$ext"
  fi

  local dst="$OUTPUTDIR/$base"
  local count=1

  while [ -e "$dst" ]; do
    count=$((count+1))
    dst="$OUTPUTDIR/${name}${count}${ext}"
  done

  cp "$src" "$dst"
}

# Формируем команду find с учетом --maxdepth если указано
if [ -z "$MAX_DEPTH" ]; then
  findcmd=(find "$INPUTDIR" -type f)
else
  findcmd=(find "$INPUTDIR" -maxdepth "$MAXDEPTH" -type f)
fi

while IFS= read -r file; do
  copywithsuffix "$file"
done < <("${findcmd@}")

exit 0
