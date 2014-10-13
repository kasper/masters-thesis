#!/bin/bash

usage() {

    echo 'Usage: [<clean>] filename.tex'
    exit 0
}

argument_exists() {

    if [ -z "$1" ]; then
        usage
        exit 0
    fi
}

file_exists() {

    if [ ! -f "$1" ]; then
        echo "File '$1' not found."
        exit 0
    fi
}

tex_file() {

    file=$1
    basename=$(basename "$file")
    extension="${basename##*.}"

    if [ "$extension" != 'tex' ]; then
        echo 'Expecting a .tex file.'
        exit 0
    fi
}

argument_exists $1

if [ "$1" == 'clean' ]; then

    file=$2
    dirname=$(dirname "$file")
    basename=$(basename "$file")
    filename="${basename%.*}"

    argument_exists $file
    file_exists $file
    tex_file $file

    cd $dirname
    rm -f $filename.aux $filename.bbl $filename.blg $filename.log $filename.out $filename.pdf $filename.toc

    exit 0
fi

file=$1
dirname=$(dirname "$file")
basename=$(basename "$file")
filename="${basename%.*}"

file_exists $file
tex_file $file

cd $dirname
pdflatex $basename
bibtex $filename
pdflatex $basename
pdflatex $basename
