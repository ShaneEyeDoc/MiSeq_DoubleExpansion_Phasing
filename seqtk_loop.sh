# Purpose: Extract sequences from FASTQ files based on name_list files using seqtk subseq
# Loop version of seqtk.sh. 
#This script loops through all Read 1 (forward read) FASTQ files in the input folder and extracts sequences based on the name_list files (containing list of read IDs as extracted by comb_match_phasing.sh[Briefly, it extracts read_ID from R2 reads based on the polymorphic segment of the CTC motif and phased it]) in the name_list folder. The output FASTQ files are R1 fastq splitted based on the polymorphic segment of the CTC motif, and they are saved to the output directory. The output FASTQ files are named based on the input FASTQ file name and the CTC motif identifier. The CTC motif identifier is usually the number of repeats in the polymorphic CTC motif.

#!/bin/bash

# Input FASTQ folder
fastq_folder="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/RawData/"

# Folder containing name_list files
name_list_folder="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/Phased"

# Output directory
output_directory="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/TestOutput"

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Iterate through input FASTQ files in the folder
for in_fastq in "$fastq_folder"/*_R1_001.fastq; do
    if [ -e "$in_fastq" ]; then
        # Extracting the base name from the FASTQ file (excluding extension). The basename command is used to extract the base name from the FASTQ file. The -s .fastq option is used to remove the .fastq extension from the base name.
        base_name=$(basename "${in_fastq%.fastq}")
        echo "Processing FASTQ file: $in_fastq"
        
        # Remove the "_R1_001" part from the base name
        base_name_without_suffix="${base_name%_R1_001}"
        echo "Base name without suffix: $base_name_without_suffix"

        # Iterate through name_list files in the folder
        for name_list_file in "$name_list_folder"/*"${base_name_without_suffix}_R2_001"*.txt; do
            if [ -e "$name_list_file" ]; then
                # Extracting the CTC motif identifier from the name_list file. The awk -F'[_ .]' '{print $(NF-1)}' command is used to process the printed value. The -F'[_ .]' option sets the field separator to either a "_" or a ".". This means that the string is split into fields wherever a "_" or a "." is found. The print $(NF-1) command prints the second last field, which is the number of repeats.
                ctc_motif=$(awk -F'[_ .]' '{print $(NF-1)}' <<< "$name_list_file")
                echo "CTC motif: $ctc_motif"

                # Generating the output FASTQ file path with the CTC motif identifier
                out_fastq="$output_directory/${base_name}_${ctc_motif}.fastq"

                # Perform sequence extraction using seqtk subseq
                seqtk subseq "$in_fastq" "$name_list_file" > "$out_fastq"

                # Display a message indicating completion
                echo "Sequences extracted from $in_fastq based on $name_list_file and saved to $out_fastq"
            fi
        done
    fi
done
