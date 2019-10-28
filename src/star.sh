#! /bin/bash

#ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/gencode.v32.annotation.gtf.gz
STAR --runMode genomeGenerate ...


STAR ...
samtools out.sam > out.bam

rm out.sam
