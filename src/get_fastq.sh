#! /bin/bash

# Hsapiens
data="/home/rstudio/disk"
mkdir -p $data # Si jamais la ligne d'avant n'avait pas marché
cd $data
mkdir -p sra_data # On crée un nouveau dossier sra_data
cd sra_data

SRR="SRR3308972
SRR3308973
SRR3308974
SRR3308975
"
#responder before after before after treatment

for srr in $SRR # $: valeur de la variable
do
# Produces one fastq file, single end data. 
fastq-dump $srr -O $data/sra_data -X 10000 #on prend les 4 premiers reads. Mettre 10 000

# rename sequence names
#awk  -F "\."  '{ if (NR%2 == 1 ) { $3= "" ; print $1 "_" $2 "/1"}  else  { print $0} }'
#...
done
