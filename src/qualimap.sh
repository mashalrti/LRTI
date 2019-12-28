#! /bin/bash
# On installe la dernière librairie nécessaire
#sudo apt-get install libxtst6 -y

mkdir -p /home/rstudio/disk/SRR_tri_bam # -p indique qu'il faut créer le nouveau répertoire seulement s'il n'existe pas déjà

SRR="
SRR3308956
SRR3308957
SRR3308972
SRR3308973
SRR3308974
SRR3308975
"

# D'abord on génère les bam triés :
#cd /home/rstudio/disk/star/
# qualimap demande d'avoir des bam triés par nom
#@ nb de coeurs utilisés
#for srr in $SRR;
#do
#echo $srr'_star'/$srr'.bam'
#samtools sort -n \
#  -O bam \
#  -o /home/rstudio/disk/SRR_tri_bam/$srr'_trie'.bam \
#  -@ 7 \
#  $srr'_star'/$srr'.bam'
#done



cd /home/rstudio/disk/
mkdir -p qualimap_output

# Je lance qualimap sur tous les échantillons :
# Je lui donne l'annotation du génome human (introns, exons, intergénique)
# Je lui dis où stocker la sortie
# Je lui donne les bam triés
# On est en paired-end
# On donne en input des bam déjà triés
# On limite la RAM à utiliser, sinon ça plantait
# On indique que le protocole de séquançage est straand-specific forward
# Pour l'algo de comptage on prend 'proportionnel'. On aligne les reads 'proportionnellement' à leur score. Sinon, on
#alignerait simplement le read avec score maximal, pour une séquence donnée.

for srr in $SRR;
do
echo $srr
qualimap rnaseq \
  -gtf /home/rstudio/disk/ref_transcripts/Hsap_annotation.gtf \
  -outdir /home/rstudio/disk/qualimap_output/$srr'_quali' \
  -outfile /home/rstudio/disk/qualimap_output/$srr'_quali'/$srr'_qualimap.pdf' \
  -bam /home/rstudio/disk/SRR_tri_bam/$srr'_trie'.bam \
  -pe \
  -s \
  --java-mem-size=20G \
  -p strand-specific-forward \
  -a proportional
done
