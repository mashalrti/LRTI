#! /bin/bash
## Run trimmomatic

data="/home/rstudio/disk"
cd $data
mkdir -p trimmo_files
mkdir -p paired # On va séparer les outputs paired et unpaired
mkdir -p unpaired
cd trimmo_files


SRR=`ls /home/rstudio/disk/sra_data/*.fastq`

for fn in $SRR;
do
	java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar \
	  PE \
	  -threads 8 \
	  $fn'_1.fastq' $fn'_2.fastq' \
	  /home/rstudio/disk/trimmo_files/paired/$fn'_paired_output_1.fastq' /home/rstudio/disk/trimmo_files/unpaired/$fn'_unpaired_output_1.fastq' \
	  /home/rstudio/disk/trimmo_files/paired/$fn'_paired_output_2.fastq' /home/rstudio/disk/trimmo_files/unpaired/$fn'unpaired_output_2.fastq' \
	  ILLUMINACLIP:/home/rstudio/disk/overrepresented.fa:2:30:10 \
	  LEADING:22 \
	  SLIDINGWINDOW:4:22 \
	  MINLEN:25

done

PE [-threads <threads] [-phred33 | -phred64] [-trimlog <logFile>] <input 1> <input 2> <paired output 1> <unpaired output 1> <paired output 2> <unpaired output 2> <step 1> 