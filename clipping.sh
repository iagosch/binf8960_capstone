end1='_1'
end2='_2'

suffix='.fastq.gz'
fq='.fq'
log='.log'

in1="$1$end1$suffix"
in2="$1$end2$suffix"

pe1='_PE_1'
sr1='_SR_1'
pe2='_PE_2'
sr2='_SR_2'

fpe1="$1$pe1$fq"
fsr1="$1$sr1$fq"
fpe2="$1$pe2$fq"
fsr2="$1$sr2$fq"


data_folder=/home/ibs37546/data

cd /home/ibs37546/data/

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads 12 $in1 $in2 $fpe1 $fsr1 $fpe2 $fsr2 ILLUMINACLIP:$data_folder/NexteraPE-PE.fa:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:25

