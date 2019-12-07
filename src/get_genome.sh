# Ici on télécharge le génome d'Homo sapiens
cd /home/rstudio/disk/ref_transcripts

#Télécharge une URL, -O : output
wget -O Hsap_annotation.gtf.gz 'ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/gencode.v32.annotation.gtf.gz'
wget -O Hsap_genome.fa.gz 'https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz'

#Décompression des fichiers .gz
gunzip Hsap_annotation.gtf.gz Hsap_annotation.gtf
gunzip Hsap_genome.fa.gz Hsap_genome.fa