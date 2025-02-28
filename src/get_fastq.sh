#! /bin/bash
# Ici nous allons importer les fichiers fastq

data="/home/rstudio/disk"
mkdir -p $data # On crée le dossier data dans disk
cd $data # Et on se met dedans
mkdir -p sra_data # Puis on crée un nouveau dossier sra_data
cd sra_data # Et on se met dedans

# On liste les échantillons à importer : j'avais importé quatre pour les tests puis deux autres pour faire les analyses sur trois par condition
#SRR="SRR3308972
#SRR3308973
#SRR3308974
#SRR3308975
#"
#responder before after before after treatment

SRR="SRR3308956
SRR3308957
"
#responder before and after

for srr in $SRR # $: valeur de la variable: on parcourt les échantillons dans $SRR
do
# On va créer un fichier fastq
#fastq-dump $srr -O $data/sra_data -X 10000 # On avait pris les 10 000 premiers reads pour tester
fastq-dump --split-files -I $srr -O $data/sra_data # --split-files sert aux paired-end, -I sert à rajouter les read ID à la fin
# awk restructure les fichiers:
# -F précise le champ où on va couper
# "\." indique qu'on coupe aux "."
# NR%2 == 1 : on regarde les lignes impaires, donc celles qui ne contiennent pas les séquences de nt
# On enlève la troisième colonne qui ne sert à rien, sauf pour les lignes avec les séquences qu'on ne modifie pas
# On fait ça pour chaque échantillon et on stock dans un fichier temporaire, puis on écrase le fichier de base avec ces
#données restructurées.
awk  -F "\."  '{ if (NR%2 == 1 ) { $3= "" ; print $1 "_" $2 "/1"}  else  { print $0} }' $srr'_1.fastq' > fichier_temp.fastq
mv fichier_temp.fastq $srr'_1.fastq'
awk  -F "\."  '{ if (NR%2 == 1 ) { $3= "" ; print $1 "_" $2 "/2"}  else  { print $0} }' $srr'_2.fastq' > fichier_temp.fastq
mv fichier_temp.fastq $srr'_2.fastq'
done