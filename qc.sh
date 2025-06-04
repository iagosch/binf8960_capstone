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
ml SAMtools/1.18-GCC-12.3.0
ml BCFtools/1.18-GCC-12.3.0
ml MultiQC/1.14-foss-2022a

#Data folder

#I have no idea why setting the data folder does not work
data_folder="/home/ibs37546/data"

# The genome and reads were downloaded from online databases, in this case NCBI.
# The first step is to evaluate the quality of the reads with FastQC

# for some dumb reason, fastqc does not work by using paths, so we need to go in the data folder,
# with cd
cd ~/data/
fastqc -t 8 --nogroup --noextract *.fastq.gz
multiqc -o ~/data/ ~/data/

# Trimming the reads using Trimmomatic, it is important to point to the software where the file containing the Nextera adapters sequences is.
# I made a list containing the sequencing samples
# And a separate script named "clipping.sh" containing the trimmomatic command

cd ~/ecoli/

cat ./list | while read in; do bash clipping.sh "$in"; done

mv ~/data/*.fq ~/data/trimmed/  #moving trimmed files to a separate folder

# New fastqc to check if adapters were correctly removed
cd /home/ibs37546/data/trimmed/
fastqc -t 8 --nogroup --noextract *.fq

multiqc -o ~/data/trimmed/ ~/data/trimmed/

# Indexing the genome for alignment
bwa index $data_folder/ecoli_reference.fna

# Align the trimmed samples to the reference genome
for fwd in /home/ibs37546/ecoli/trimmed/*_PE_1.fq
do
	sample=$(basename $fwd _PE_1.fq)
	echo "Aligning $sample"
	rev=$data_folder/trimmed/${sample}_PE_2.fq
	bwa mem $data_folder/ecoli_reference.fna $fwd $rev > ~/ecoli/results/$sample.sam

	#convert to BAM and sort the files
	samtools view -S -b ~/ecoli/results/$sample.sam > ~/ecoli/results/$sample.bam
	samtools sort -o ~/ecoli/results/*.sorted.bam ~/ecoli/results/*.bam

	#variant calling
        echo "Variant calling in file $sample"
        bcftools mpileup -O b -o ~/ecoli/results/$sample.bcf -f $data_folder/ecoli_reference.fna ~/ecoli/results/$sample.sorted.bam
        bcftools call --ploidy 1 -m -v -o ~/ecoli/results/$sample.vcf ~/ecoli/results/$sample.bcf

done
