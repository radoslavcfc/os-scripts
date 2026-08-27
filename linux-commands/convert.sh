#!/bin/bash

# Enable globstar to allow recursive ** matching
shopt -s globstar

# Loop through all .flac files recursively in subfolders
for flac in **/*.flac; do
    # Get the directory and filename
    dir=$(dirname "$flac")
    filename=$(basename "$flac")
    
    # Define the output directory (appends -mp3 to the parent folder path)
    outdir="${dir}-mp3"
    
    # Create the output directory if it doesn't exist
    mkdir -p "$outdir"
    
    # Define output file path
    output="${outdir}/${filename%.flac}.mp3"
    
    # Convert using ffmpeg
    echo "Converting: $flac -> $output"
    ffmpeg -y -i "$flac" -codec:a libmp3lame -b:a 320k "$output" >/dev/null 2>&1
done

echo "All conversions complete!"
