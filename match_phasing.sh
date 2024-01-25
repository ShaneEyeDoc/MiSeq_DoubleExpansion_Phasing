#!/bin/bash

# Input fastq file
input_fastq="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/RawData/MS340-N706-A-S507-A_S54_L001_R2_001.fastq"

# Reference list CSV file
reference_list="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/allele_CTC_list.csv"

# Extract mid part of the fastq file name
file_name=$(basename "$input_fastq")
mid_part=$(echo "$file_name" | awk -F'[-]' '{print $1"-"$2"-"$3"-"$4}')

# Match mid part with sample_key in the reference list
sample_info=$(grep "$mid_part" "$reference_list")

# Display numbers after CTC in r2_short_ctc and r2_long_ctc columns
r2_short_ctc=$(echo "$sample_info" | awk -F'[][]' '{print $2}')
r2_long_ctc=$(echo "$sample_info" | awk -F'[][]' '{print $4}')

# Display the results
echo "Sample Key: $mid_part"
echo "r2_short_ctc: $r2_short_ctc"
echo "r2_long_ctc: $r2_long_ctc"
