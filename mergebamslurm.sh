#!/bin/bash

#SBATCH -J mergebam
#SBATCH -o mergebam.%j.out
#SBATCH -e mergebam.%j.error
#SBATCH --partition=batch
#SBATCH --mail-user=rosechellejoyoraa@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --requeue

home='/home/rosechelle.oraa'
genomedir='scratch2/output'
rawDir='IRIS_313-10519'

module load samtools/1.0-intel

#merge bam files
perl mergebam.pl $home/$genomedir $rawDir
