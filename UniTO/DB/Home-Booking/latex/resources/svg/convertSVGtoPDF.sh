#!/bin/bash
mkdir "$PWD"/../pdf
for file in $PWD/*.svg
    do
        filename=$(basename "$file")
        inkscape --without-gui --export-pdf="$PWD"/../pdf/"${filename%.svg}.pdf" "$file"
    done
