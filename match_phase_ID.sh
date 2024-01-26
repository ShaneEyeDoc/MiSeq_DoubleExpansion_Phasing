#This script allows for the matching of the phase ID (i.e. the polymorphic first CTC segment of the CTC motif) to the corresponding fastq file and then extracts the matching sequences ID for each allele and save as text file.
#Work with individual fastq file rather than a folder of fastq files. This is useful for testing the script or if the loop in comb_match_phasing.sh is not working properly.
#!/bin/bash

# Input fastq file
input_fastq="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/RawData/AS1-N702-C-S516-C_S218_L001_R2_001.fastq"

# Reference list CSV file
reference_list="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/allele_CTC_ref.csv"

# Output directory for Allele_1 and Allele_2 read ids
output_directory="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/TestOutput"

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Check if the file is an R2 fastq file
if [ ! -f "$input_fastq" ]; then
    echo "Error: Input fastq file not found!"
    exit 1
fi

# Extract mid (i.e. MiSeqID) part of the fastq file name
file_name=$(basename "$input_fastq")
mid_part=$(echo "$file_name" | awk -F'[-_]' '{print $1"-"$2"-"$3"-"$4}')

# Match mid (i.e. MiSeqID) part with sample_key in the reference list
sample_info=$(grep "$mid_part" "$reference_list")

# Display numbers after CTC in r2_allele_1_ctc and r2_allele_2_ctc columns
r2_ctc_1=$(echo "$sample_info" | awk -F',' '{print $2}')
r2_ctc_2=$(echo "$sample_info" | awk -F',' '{print $3}')

# Display the results
echo "Sample Key: $mid_part"
echo "r2_ctc_1: $r2_ctc_1"
echo "r2_ctc_2: $r2_ctc_2"

# Sanitize the sequence for filenames
sanitized_sequence_allele_1=$(echo "$r2_ctc_1" | tr -d '[]')
sanitized_sequence_allele_2=$(echo "$r2_ctc_2" | tr -d '[]')

#Count the number of polymorphic CTC segment of the motif
repeat_count_1=$(echo "$r2_ctc_1" | awk -F'[\\[\\]]' '{print $3}')
repeat_count_2=$(echo "$r2_ctc_2" | awk -F'[\\[\\]]' '{print $3}')

# Generate the dynamic sequence for Allele_1
sequence_to_match_allele_1="AAG$(printf 'GAG%.0s' $(seq "$repeat_count_1"))CAG"

# Generate the dynamic sequence for Allele_2
sequence_to_match_allele_2="AAG$(printf 'GAG%.0s' $(seq "$repeat_count_2"))CAG"

echo "Sanitized sequence for Allele_1: $sanitized_sequence_allele_1"
echo "Sanitized sequence for Allele_2: $sanitized_sequence_allele_2"
echo "Repeat count Allele_1: $repeat_count_1"
echo "Repeat count Allele_1: $repeat_count_2"
echo "Sequence to match for Allele_1: $sequence_to_match_allele_1"
echo "Sequence to match for Allele_2: $sequence_to_match_allele_2"

# Output fastq file with r2_allele_1_ctc suffix
output_fastq_allele_1="$output_directory/$(basename "${input_fastq%.fastq}")_CTC${repeat_count_1}.txt"

# Output fastq file with r2_allele_2_ctc suffix
output_fastq_allele_2="$output_directory/$(basename "${input_fastq%.fastq}")_CTC${repeat_count_2}.txt"

# Extract matching sequences, write corresponding read id (i.e., first line for each group of 4 lines: NR % 4 == 1) without @ and "" 2:N.*"" for Allele_1
awk -v seq="$sequence_to_match_allele_1" 'BEGIN{OFS="\t"} {if (NR % 4 == 1) {header=$1; gsub(/^@| 2:N.*/, "", header); getline seq_line; if (seq_line ~ seq) print header}}' "$input_fastq" > "$output_fastq_allele_1"

echo "Allele_1 matching sequences saved to: $output_fastq_allele_1"

# Extract matching sequences, write corresponding read id (i.e., first line for each group of 4 lines: NR % 4 == 1) without @ and "" 2:N.*"" for Allele_2
awk -v seq="$sequence_to_match_allele_2" 'BEGIN{OFS="\t"} {if (NR % 4 == 1) {header=$1; gsub(/^@| 2:N.*/, "", header); getline seq_line; if (seq_line ~ seq) print header}}' "$input_fastq" > "$output_fastq_allele_2"

echo "Allele_2 matching sequences saved to: $output_fastq_allele_2"

