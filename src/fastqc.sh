#! /bin/bash

data="/home/rstudio/disk"
cd $data
mkdir -p fastqc_files # On crée un nouveau dossier sra_data
cd fastqc_files

#FASTQ=`ls /home/rstudio/disk/sra_data/*.fastq` #all the fastq files
FASTQ=`ls /home/rstudio/disk/sra_data/SRR330895[6-7]*.fastq` #just the two samples I added afterwards


for file in $FASTQ # $: valeur de la variable
do
# Produces one fastq file, single end data.
echo $file
#fastqc "/home/rstudio/disk/sra_data/"$file -o "/home/rstudio/disk/fastqc_files" #to do all of the files
fastqc $file -o "/home/rstudio/disk/fastqc_files" #just the selected files

#...
done