#! /bin/bash
# Dans ce script, on lance salmon pour faire le pseudoalignement des reads nettoyés sur le génome de référence

#cd /home/rstudio/disk
#mkdir salmon_quant
#cd /home/rstudio/disk/ref_transcripts/Hsap_cDNA.fa

SRR="
SRR3308956
SRR3308957
SRR3308972
SRR3308973
SRR3308974
SRR3308975
"

# D'abord on génère l'index, ce qui est nécessaire car nous n'avons pas les fichiers BAM :
# j'utilise un hash de k-mer de longueur 20
#salmon index -t /home/rstudio/disk/ref_transcripts/Hsap_cDNA.fa \
#  -i /home/rstudio/disk/salmon_index
#  -k 20

#We had some shorter reads so changed k from 31 to 25


#files=`ls /home/rstudio/disk/trimmo_files/paired/SRR33089[56-75].*.fastq`
for object in $SRR:
do
#-1 brin forward nettoyé par Trimmomatic
#-2 brin reverse
#-i index que l'on vient de générer
#--validateMappings pour un mapping plus efficace : utilise un score et un processus de validation
#-o output
#-p nombre de threads
#gcBias corrige les biais de taux de GC
salmon quant -l A \
  -1 /home/rstudio/disk/trimmo_files/paired/$object'_paired_output_1.fastq' \
  -2 /home/rstudio/disk/trimmo_files/paired/$object'_paired_output_2.fastq' \
  -i /home/rstudio/disk/salmon_index \
  --validateMappings \
  -o /home/rstudio/disk/salmon_quant/$object'paired_quant' \
  -p 8 \
  --gcBias
echo $object
done