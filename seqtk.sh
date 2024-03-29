#This script uses seqtk to extract sequences from a FASTQ file based on a list of read ID. The list of read id is usually generated by the match_phase_ID.sh script. The seqtk subseq command is used to extract the sequences from the FASTQ file. The seqtk subseq command requires the FASTQ file and the list of sequence names as input. The output is saved to a new FASTQ file. The FASTQ file is usually the R1 FASTQ file and the list of sequence names is usually the phased R2 reads ID in .txt format as a list (a list of CTC6 and a list CTC7 etc). The output FASTQ file is usually the R1 FASTQ file with the CTC motif identifier appended to the file name. The CTC motif identifier is usually the number of repeats in the polymorphic CTC motif. 
#!/bin/bash

# Input FASTQ file
in_fastq="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/RawData/AS1-N703-A-S506-A_S39_L001_R1_001.fastq"

# List file containing sequence names
name_list="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/TestOutput/AS1-N703-A-S506-A_S39_L001_R2_001_CTC7.txt"

# Output directory
output_directory="/Users/shane/Library/CloudStorage/OneDrive-UniversityCollegeLondon/Medicine/Ophthalmology_ST/PhD/MiSeq/DoubleExpanded/TestOutput"

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Extracting the base name from the FASTQ file (excluding extension)
base_name=$(basename "${in_fastq%.fastq}")

# Extracting the CTC motif identifier from the name_list file
ctc_motif=$(awk -F'[_ .]' '{print $(NF-1)}' <<< "$name_list")

# Generating the output FASTQ file path with the CTC motif identifier
out_fastq="$output_directory/${base_name}_${ctc_motif}.fastq"

# Perform sequence extraction using seqtk subseq
seqtk subseq "$in_fastq" "$name_list" > "$out_fastq"

# Display a message indicating completion
echo "Sequences extracted from $in_fastq based on $name_list and saved to $out_fastq"