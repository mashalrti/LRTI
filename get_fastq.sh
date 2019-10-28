#! /bin/bash

# Hsapiens
data="/home/rstudio/TP_RNAseq_Medical"
mkdir -p $data
cd $data
mkdir -p sra_data
cd sra_data

SRR="SRR3308950
SRR3308951
SRR3308952
"

for srr in $SRR
do
# Produces one fastq file, single end data. 
fastq-dump -h

# rename sequence names
awk  -F "\."  '{ if (NR%2 == 1 ) { $3= "" ; print $1 "_" $2 "/1"}  else  { print $0} }'
...
done
