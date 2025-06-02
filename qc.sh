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


ml
