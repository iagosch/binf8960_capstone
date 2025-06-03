#!/bin/bash
#SBATCH --job-name=QC
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mail-type=END,FAIL
#SBATCH --error=QC_%j.err
#SBATCH --out=QC_%j.out
#SBATCH --mem=32gb
#SBATCH --time=72:00:00

# This is a basic genomic analysis script. The goal is to QC, Trim and align reads to a reference genome

#Loading modules from the cluster before the analysis

ml FastQC/0.11.9-Java-11
ml Trimmomatic/0.39-Java-13
ml BWA/0.7.18-GCCcore-13.3.0

data_folder = /home/ibs37546/data

# The genome and reads were downloaded from online databases, in this case NCBI.
# The first step is to evaluate the quality of the reads with FastQC
fastqc -t 1 --nogroup --noextract $data_folder/*fastq.gz

# Trimming the reads using Trimmomatic, it is important to point to the software where the file containing the Nextera adapters sequences is.
cat ./list | while read in; do bash clipping.sh "$in"; done

#there are still some errors at the end, but it works for now
