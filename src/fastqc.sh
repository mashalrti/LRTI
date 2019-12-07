#! /bin/bash
# Ici, nous allons générer les fastqc à partir des fichiers fastq

data="/home/rstudio/disk"
cd $data
# Maintenant on crée un nouveau dossier où on va mettre les fichiers fastqc et on se place dedans :
mkdir -p fastqc_files
cd fastqc_files

# On nomme les fichiers que l'on veut traiter ; j'avais d'abord lancé sur mes quatre échantillons puis sur les deux nouveaux
#FASTQ=`ls /home/rstudio/disk/sra_data/*.fastq # Ici je prends tous les fastq du dossier
FASTQ=`ls /home/rstudio/disk/sra_data/SRR330895[6-7]*.fastq` # Ici je prends seulement les fichiers se terminant par 56 et 57


for file in $FASTQ
do
#echo $file # Le echo servait à vérifier que la boucle tourne
#fastqc "/home/rstudio/disk/sra_data/"$file -o "/home/rstudio/disk/fastqc_files" # Pour tous les fichiers
fastqc $file -o "/home/rstudio/disk/fastqc_files" # Et juste les deux derniers
done
# et bim