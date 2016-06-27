#!/bin/bash
arg = "$1"
perl createAlignmentSlurm.pl input.info $arg
step1 = sbatch ../analysis/$arg/submit_slurm.sh

perl createBAMProcessingSlurm.pl input.info $arg
step2 = sbatch --dependency=afterok:$step1 ../analysis/$arg/submit_sam2bam_slurm.sh

step3 = sbatch --dependency=afterok:$step2 python mergebam.py -g ../analysis/<arg1>

bam2vcf.py -b ../scratch2/output -r ../reference -g ../software/GenomeAnalysisTK-3.2-2 -t temp_dir

sbatch --dependency=afterany:$step3 vcfToTable.sh





