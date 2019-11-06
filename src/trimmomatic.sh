#! /bin/bash
## Run trimmomatic

data="/home/rstudio/disk"
cd $data
mkdir -p trimmo_files
cd trimmo_files
mkdir -p paired # On va séparer les outputs paired et unpaired
mkdir -p unpaired

#SRR=`ls /home/rstudio/disk/sra_data/*.fastq`
#SRR=`ls /home/rstudio/disk/sra_data/SRR33089[56-75]*.fastq
SRR="
SRR3308956
SRR3308957
SRR3308972
SRR3308973
SRR3308974
SRR3308975
"

for fn in $SRR;
do
  #echo $fn
	java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar \
	  PE \
	  -threads 8 \
	  /home/rstudio/disk/sra_data/$fn'_1.fastq' /home/rstudio/disk/sra_data/$fn'_2.fastq' \
	  /home/rstudio/disk/trimmo_files/paired/$fn'_paired_output_1.fastq' /home/rstudio/disk/trimmo_files/unpaired/$fn'_unpaired_output_1.fastq' \
	  /home/rstudio/disk/trimmo_files/paired/$fn'_paired_output_2.fastq' /home/rstudio/disk/trimmo_files/unpaired/$fn'_unpaired_output_2.fastq' \
	  ILLUMINACLIP:/home/rstudio/disk/overrepresented.fa:2:30:10 \
	  LEADING:22 \
	  SLIDINGWINDOW:4:22 \
	  MINLEN:25

done
