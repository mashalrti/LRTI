#! /bin/bash
# On installe la dernière librairie nécessaire
#sudo apt-get install libxtst6 -y

#mkdir -p /home/rstudio/disk/SRR_tri_bam

SRR="
SRR3308956
SRR3308957
SRR3308972
SRR3308973
SRR3308974
SRR3308975
"

# D'abord on génère les bam triés :
cd /home/rstudio/disk/star/
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

for srr in $SRR;
do
echo $srr
qualimap rnaseq \
  -gtf /home/rstudio/disk/ref_transcripts/Hsap_annotation.gtf
  -outdir /home/rstudio/disk/qualimap_output/$srr'_quali' \
  -outfile /home/rstudio/disk/qualimap_output/$srr'_quali'/$srr'_qualimap.pdf'
  -bam /home/rstudio/disk/SRR_tri_bam/$srr'_trie'.bam \
  -s,--sorted
done