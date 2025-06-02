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

# The genome and reads were downloaded from online databases, in this case NCBI.

