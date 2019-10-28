#! /bin/bash
## Run trimmomatic
SRR="SRR3308950
SRR3308951
SRR3308952
"

for fn in $SRR;
do
	java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar -h

done

