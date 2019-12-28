#! /bin/bash
# Ce script fait tourner Star, qui aligne des transcrits epissés sur une séquence de référence

#cd /home/rstudio/disk/ref_transcripts
# Indexer des génomes demande beaucoup de RAM et nous n'arrivons pas à générer l'index entier
# On a essayé de rajouter '--genomeChrBinNbits=min(18, log2(GenomeLength/NumberOfReferences))' mais cela n'a pas
#résolu le problème.
# Donc on va faire un subset du génome en ne gardant que les chromosomes.
# D'abord, on récupère les headers qu'on veut garder:
#grep ">"  Hsap_genome.fa |grep -v "_" |sed 's/>//g'> chr.txt
# Puis on extrait du génome juste les headers choisis:
#xargs samtools faidx Hsap_genome.fa < chr.txt > genome_chr.fa
# J'ai vérifié que genome_chr.fa contient seulement les chromosomes et je lance l'index sur genoms_chr.fa

cd /home/rstudio/disk
mkdir -p star/index


SRR="
SRR3308956
SRR3308957
SRR3308972
SRR3308973
SRR3308974
SRR3308975
"

# Génération de l'index du génome humain annoté, avec 8 coeurs :
# sjdbOverhang indique à STAR combien de bases il faut concatener entre les côtés donneur et receveur des jonctions
#STAR --runThreadN 8 --runMode genomeGenerate \
#  --genomeDir star/index \
#  --genomeFastaFiles /home/rstudio/disk/ref_transcripts/genome_chr.fa \
#  --sjdbGTFfile /home/rstudio/disk/ref_transcripts/Hsap_annotation.gtf \
#  --sjdbOverhang 100

paired=/home/rstudio/disk/trimmo_files/paired

for srr in $SRR;
do
#echo $srr
#echo $paired/$srr'_paired_output_1.fastq'

#Création d'un nouveau répertoire pour stocker le résultat :
mkdir /home/rstudio/disk/star/$srr'_star'
cd /home/rstudio/disk/star/$srr'_star'

# Quantification des reads :
STAR --runThreadN 8 --genomeDir /home/rstudio/disk/Corentin/hg38_genome \
  --readFilesIn $paired/$srr'_paired_output_1.fastq' \
  $paired/$srr'_paired_output_2.fastq'
  
#Le fichier Aligned.out.sam est renvoyé par STAR, mais il est trop gros -> conversion en .bam, plus léger, puis suppression de l'ancien fichier
samtools view -bS -h Aligned.out.sam > $srr'.bam'
rm Aligned.out.sam

done
