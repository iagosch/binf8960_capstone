#!/bin/bash

#I used Qualimap to get the alignment stats. It produces both a txt file and an html file.
# For this report, I only used the .txt file

ml Qualimap/2.2.1-foss-2021b-R-4.1.2

bam_dir="~/ecoli/results/"


for bam_file in $bam_dir/*.sorted.bam; do
        sample_name=$(basename $bam_file .sorted.bam)
        qualimap bamqc -bam $sample_name
done
