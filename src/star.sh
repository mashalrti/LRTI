#! /bin/bash

cd /home/rstudio/disk
#mkdir -p star/index

#Liste des SRR d'intérêt
SRR="
SRR3308956
SRR3308957
SRR3308972
SRR3308973
SRR3308974
SRR3308975
"

#génération de l'index du génome humain annoté, avec 8 coeurs
#STAR --runThreadN 8 --runMode genomeGenerate \
#  --genomeDir star/index \
#  --genomeFastaFiles /home/rstudio/disk/ref_transcripts/Hsap_genome.fa \
#  --sjdbGTFfile /home/rstudio/disk/ref_transcripts/Hsap_annotation.gtf \
#  --sjdbOverhang 100

paired=/home/rstudio/disk/trimmo_files/paired

for srr in $SRR;
do
#echo $srr
#echo $paired/$srr'_paired_output_1.fastq'
#Création d'un nouveau répertoire
cd /home/rstudio/disk
mkdir star/$srr'_star'
cd star/$srr'_star'
#Quantification des reads
STAR --runThreadN 8 --genomeDir /home/rstudio/disk/star/index \
  --readFilesIn $paired/$srr'_paired_output_1.fastq' \
  $paired/$srr'_paired_output_2.fastq'
  
#Le fichier Aligned.out.sam est renvoyé par STAR, mais il est trop gros -> conversion en .bam, plus léger, puis suppression de
#l'ancien fichier
samtools view -bS -h Aligned.out.sam > $srr'.bam'
rm Aligned.out.sam

done