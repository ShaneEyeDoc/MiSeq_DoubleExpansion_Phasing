#!/bin/bash

# Reference list CSV file
reference_list="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/Scripts/allele_CTC_list.csv"

# Extract sample keys from the reference list and remove extra characters
sample_keys=$(awk -F'[[:space:]]*\\|[[:space:]]*' 'NR > 1 {print $2}' "$reference_list")

# Source folders
source_folder_r1="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/AmandaRawdata/AS2 data/AS2_RawReads/AS2_RawReads/R1"
source_folder_r2="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/AmandaRawdata/AS2 data/AS2_RawReads/AS2_RawReads/R2"
source_folder_as1="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/AmandaRawdata/AS1 data/AS1_RawReads"

# Destination folder
destination_folder="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/RawData"  # Set the actual destination folder

# Loop through sample keys and copy corresponding files
for sample_key in $sample_keys; do
    # Form the source file paths for R1 and R2
    source_file_r1=$(find "$source_folder_r1" -type f -name "${sample_key}*R1*.fastq.gz" -print -quit)
    source_file_r2=$(find "$source_folder_r2" -type f -name "${sample_key}*R2*.fastq.gz" -print -quit)

    # Form the source file path for AS1
    source_file_as1_r1=$(find "$source_folder_as1" -type f -name "${sample_key}*R1*.fastq.gz" -print -quit)
    source_file_as1_r2=$(find "$source_folder_as1" -type f -name "${sample_key}*R2*.fastq.gz" -print -quit)

    # Check if the files exist before copying
    if [ -n "$source_file_r1" ]; then
        cp "$source_file_r1" "$destination_folder"
        echo "Copied $source_file_r1 to $destination_folder"
        gunzip "$destination_folder/$(basename "$source_file_r1")"
        echo "Unzipped $destination_folder/$(basename "$source_file_r1")"
    else
        echo "File not found for $sample_key in R1 folder"
    fi

    if [ -n "$source_file_r2" ]; then
        cp "$source_file_r2" "$destination_folder"
        echo "Copied $source_file_r2 to $destination_folder"
        gunzip "$destination_folder/$(basename "$source_file_r2")"
        echo "Unzipped $destination_folder/$(basename "$source_file_r2")"
    else
        echo "File not found for $sample_key in R2 folder"
    fi

    if [ -n "$source_file_as1_r1" ]; then
        cp "$source_file_as1_r1" "$destination_folder"
        echo "Copied $source_file_as1_r1 to $destination_folder"
        gunzip "$destination_folder/$(basename "$source_file_as1_r1")"
        echo "Unzipped $destination_folder/$(basename "$source_file_as1_r1")"
    else
        echo "File not found for $sample_key in AS1 folder (R1)"
    fi

    if [ -n "$source_file_as1_r2" ]; then
        cp "$source_file_as1_r2" "$destination_folder"
        echo "Copied $source_file_as1_r2 to $destination_folder"
        gunzip "$destination_folder/$(basename "$source_file_as1_r2")"
        echo "Unzipped $destination_folder/$(basename "$source_file_as1_r2")"
    else
        echo "File not found for $sample_key in AS1 folder (R2)"
    fi
done

