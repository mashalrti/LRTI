#! /bin/bash
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

#salmon index -t /home/rstudio/disk/ref_transcripts/Hsap_cDNA.fa \
#  -i /home/rstudio/disk/salmon_index
#  -k 20

#We had some shorter reads so changed k from 31 to 25

#index is independent of the reads and necessary because we don't have the BAM files
#files=`ls /home/rstudio/disk/trimmo_files/paired/SRR33089[56-75].*.fastq`
for object in $SRR:
do
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
#-1 forward strand cleaned by Trimmomatic
#-2 reverse strand
#-l library type automatic
#-i index created by salmon_index
#--validateMappings more efficient mapping; score and validation
#-o output
#-p number of threads
#gcBias corrects for GC percentage bias
