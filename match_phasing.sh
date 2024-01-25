#!/bin/bash

# Input fastq file
input_fastq="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/RawData/MS340-N706-A-S507-A_S54_L001_R2_001.fastq"

# Reference list CSV file
reference_list="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/allele_CTC_ref.csv"

# Extract mid part of the fastq file name
file_name=$(basename "$input_fastq")
mid_part=$(echo "$file_name" | awk -F'[-]' '{print $1"-"$2"-"$3"-"$4}')

# Match mid part with sample_key in the reference list
sample_info=$(grep "$mid_part" "$reference_list")

# Display numbers after CTC in r2_allele_1_ctc and r2_allele_2_ctc columns
r2_allele_1_ctc=$(echo "$sample_info" | awk -F',' '{print $2}')
r2_allele_2_ctc=$(echo "$sample_info" | awk -F',' '{print $3}')

# Display the results
echo "Sample Key: $mid_part"
echo "r2_allele_1_ctc: $r2_allele_1_ctc"
echo "r2_allele_2_ctc: $r2_allele_2_ctc"

# Output directory for Allele_1 and Allele_2 fastq files
output_directory="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/TestOutput"

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Output fastq file with Allele_1 suffix
output_fastq_allele_1="$output_directory/$(basename "${input_fastq%.fastq}")_Allele_1.fastq"

# Output fastq file with Allele_2 suffix
output_fastq_allele_2="$output_directory/$(basename "${input_fastq%.fastq}")_Allele_2.fastq"

# Customize the sequence to match for Allele_1 based on r2_allele_1_ctc
sequence_to_match_allele_1="AAG"$(printf 'GAG%.0s' $(seq "$r2_allele_1_ctc"))"CAG"

# Customize the sequence to match for Allele_2 based on r2_allele_2_ctc
sequence_to_match_allele_2="AAG"$(printf 'GAG%.0s' $(seq "$r2_allele_2_ctc"))"CAG"

# Check if input file exists
if [ ! -f "$input_fastq" ]; then
    echo "Error: Input fastq file not found!"
    exit 1
fi

# Extract matching sequences and format into original fastq style for Allele_1
awk -v seq="$sequence_to_match_allele_1" '{
    if (NR % 4 == 1) {
        id = $0
    } else if (NR % 4 == 2) {
        if (index($0, seq) > 0) {
            print id
            print $0
            getline
            print "+"
            getline
            print $0
        }
    } else if (NR % 4 == 0) {
        if (index($0, seq) > 0) {
            print "+"
            getline
            print $0
        }
    }
}' "$input_fastq" > "$output_fastq_allele_1"

echo "Allele_1 matching sequences saved to: $output_fastq_allele_1"

# Extract matching sequences and format into original fastq style for Allele_2
awk -v seq="$sequence_to_match_allele_2" '{
    if (NR % 4 == 1) {
        id = $0
    } else if (NR % 4 == 2) {
        if (index($0, seq) > 0) {
            print id
            print $0
            getline
            print "+"
            getline
            print $0
        }
    } else if (NR % 4 == 0) {
        if (index($0, seq) > 0) {
            print "+"
            getline
            print $0
        }
    }
}' "$input_fastq" > "$output_fastq_allele_2"

echo "Allele_2 matching sequences saved to: $output_fastq_allele_2"
