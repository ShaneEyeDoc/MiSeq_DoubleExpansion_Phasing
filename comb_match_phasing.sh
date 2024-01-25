#This script is used to loop through all fastq files in a folder and extract read ids for Allele_1 and Allele_2. The read ids are saved to separate text files with r2_allele_1_ctc and r2_allele_2_ctc suffixes. The script also displays the numbers after CTC in r2_allele_1_ctc and r2_allele_2_ctc columns for each fastq file. 
#!/bin/bash
 
# Input folder for fastq files
input_folder="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/RawData"
 
# Reference list CSV file
reference_list="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/allele_CTC_list.csv"
 
# Output directory for Allele_1 and Allele_2 read ids
output_directory="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/TestOutput"
 
# Create the output directory if it doesn't exist
mkdir -p "$output_directory"
 
# Loop through all fastq files in the input folder
for input_fastq in "$input_folder"/*_R2_001.fastq; do
    # Check if the file is an R2 fastq file
    if [ ! -f "$input_fastq" ]; then
        echo "Skipping $input_fastq as it is not an R2 fastq file."
        continue
    fi
 
    # Extract mid (i.e. MiSeqID) part of the fastq file name
    file_name=$(basename "$input_fastq")
    mid_part=$(echo "$file_name" | awk -F'[-_]' '{print $1"-"$2"-"$3"-"$4}')
 
    # Match mid (i.e. MiSeqID) part with sample_key in the reference list
    sample_info=$(grep "$mid_part" "$reference_list")
 
    # Display numbers after CTC in r2_allele_1_ctc and r2_allele_2_ctc columns
    r2_allele_1_ctc=$(echo "$sample_info" | awk -F'[\\[\\]]' '{print $3}')
    r2_allele_2_ctc=$(echo "$sample_info" | awk -F'[\\[\\]]' '{print $9}')
 
    # Display the results
    echo "Processing file: $input_fastq"
    echo "Sample Key: $mid_part"
    echo "r2_allele_1_ctc: $r2_allele_1_ctc"
    echo "r2_allele_2_ctc: $r2_allele_2_ctc"
 
    # Generate the dynamic sequence for Allele_1
    sequence_to_match_allele_1="AAG"$(printf 'GAG%.0s' $(seq "$r2_allele_1_ctc"))"CAG"
 
    # Generate the dynamic sequence for Allele_2
    sequence_to_match_allele_2="AAG"$(printf 'GAG%.0s' $(seq "$r2_allele_2_ctc"))"CAG"
 
    # Output fastq file with r2_allele_1_ctc suffix
    output_fastq_allele_1="$output_directory/$(basename "${input_fastq%.fastq}")_CTC"$r2_allele_1_ctc".txt"
 
    # Output fastq file with r2_allele_2_ctc suffix
    output_fastq_allele_2="$output_directory/$(basename "${input_fastq%.fastq}")_CTC"$r2_allele_2_ctc".txt"
 
    # Extract matching sequences, write correspondinng read id (i.e. first linefor each group of 4 lines: NR % 4 == 1) without @ and "" 2:N.*"" for Allele_1
    awk -v seq="$sequence_to_match_allele_1" 'NR % 4 == 1 {gsub(/^@| 2:N.*/, ""); print}' "$input_fastq" > "$output_fastq_allele_1"
 
    echo "Allele_1 matching sequences saved to: $output_fastq_allele_1"
 
    # Extract matching sequences, write correspondinng read id (i.e. first linefor each group of 4 lines: NR % 4 == 1) without @ and "" 2:N.*"" for Allele_2
    awk -v seq="$sequence_to_match_allele_2" 'NR % 4 == 1 {gsub(/^@| 2:N.*/, ""); print}' "$input_fastq" > "$output_fastq_allele_2"
 
    echo "Allele_2 matching sequences saved to: $output_fastq_allele_2"

    done