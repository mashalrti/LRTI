#! /bin/bash
# Ici on va utiliser Trimmomatic pour nettoyer les données

data="/home/rstudio/disk"
cd $data
mkdir -p trimmo_files
cd trimmo_files
mkdir -p paired # On va séparer les outputs paired et unpaired
mkdir -p unpaired

# On nomme les fichiers à prendre
# J'aurais aimé faire une boucle pour parcourir comme il faut l'ensemble des fichiers d'un dossier, mais le plus
#simple était d'écrire les noms à la main car il faut ensuite prendre les _1 et _2 pour chaque échantillon :

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
  # Ici nous avons utilisé les paramètres cités dans l'article, en utilisant les explicaions de www.usadellab.org/cms/?page=trimmomatic
  # Ligne par ligne, voici la signification du code qui suit :
  # on utilise trimmomatic (et ouais)
  # on est en paired end
  # threads correspond au nombre de coeurs qu'on va utiliser, et on n'est pas des petits joueurs, on en prend 8 !
  # on dit à la machine qu'il faut prendre le fichier se terminant par _1 pour les pairés et non pairés
  # et puis on va prendre les fichiers finissant par _2 pour chaque échantillon, pour l'autre sens du read
  # illuminaclip enlève les adaptateurs
  # leading:22 coupe les 22 premières bases qui sont considérées être de mauvaise qualité
  # slidingwindow scan le read avec une fenêtre de 4 bases, en coupant lorsque la qualité tombe en dessous de 22 (valeurs de l'article)
  # minlen : on ne prend pas en compte les reads dont la longueur est en dessous de 25 bases
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
