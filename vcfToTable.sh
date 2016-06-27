#!/bin/bash

while read file; do

java -Xmx8g -jar /shared/data/software/GenomeAnalysisTK-3.5/GenomeAnalysisTK.jar \
	-R /shared/scratch/jdetras/kkjena/reference/nipponbare/IRGSP-1.0_genome.fa \
	-T VariantsToTable \
	-V $file.vcf \
	-F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F AC -F AF -F DP \
	-o $file-table.txt \
	--allowMissingData

done<input.txt
exit
