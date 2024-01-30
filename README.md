This project is for splitting Biallelic Expanded samples' MiSeq data
Repeat expansion genotyping does not allow for accurate charaterisation of DoubleExpanded samples so we cannot tell the ePAL nor somatic mosacism of both Alleles. Hence we need to split the reads into two fastq files, one for each allele, and run RGT on each of them separately.

The scripts in this repository are used to split the fastq files into two, before generating RGT output for each of them.

1. copy_double_expanded.sh: copy the raw fastq files of double expanded samples to the desired folder

2. phasingR2.sh: Based on the CTC motif size, extract the read_ids of reads from R2 fastq files that have the specified motif size. Output is a list of read_ids that have the specified motif size.
2. phasingR2_loop.sh: loop through all the fastq files in the folder, and run phasingR2.sh on each of them. Output is a list of read_ids that have the specified motif size for each fastq file.

3. seqtk.sh: Based on the output list of read_ids from phasingR2_loop.sh, extract the reads from R1 fastq files that have the specified motif size. Output are fastq files of reads that have the specified motif size e.g. reads with CTC4 and reads with CTC6.
3. seqtk_loop.sh: loop through all the fastq files in the folder, and run seqtk.sh on each of them. 