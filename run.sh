#!/bin/bash

chmod u+x format_reference.sh
./format_reference

perl createAlignmentSlurm.pl input.info $1
step1 = $(sbatch home/rosechelle.oraa/analysis/$1/submit_slurm.sh)

perl createBAMProcessingSlurm.pl input.info $1
step2 = $(sbatch --dependency=afterany:$step1 ../analysis/$1/submit_sam2bam_slurm.sh)

step3=(sbatch --dependency=afterok:$step2 mergebamslurm.sh)
#perl mergebam.pl home/rosechelle.oraa/scratch2/output/ IRIS-313-10519
#python bam2vcf.py -b ../scratch2/output -r ../reference -g ../software/GenomeAnalysisTK-3.2-2 -t temp_dir
#gzip ../scratch2/output/*.vcf 
