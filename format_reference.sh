#!/bin/bash

#SBATCH -J format_reference     
#SBATCH -o format_reference.%j.out   
#SBATCH -e format_reference.%j.error
#SBATCH --partition=batch
#SBATCH --mail-user=rcoraa@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --requeue

home='/home/rosechelle.oraa'
reference='reference/chrM.fa'
bwa_index='bwa index'
create_dictionary='software/picard-tools-1.119/CreateSequenceDictionary.jar'
samtools_faidx='samtools faidx'
dictionary_output='reference/chrM.dict'

module load bwa/0.7.10-intel
module load samtools/1.0-intel
#Index reference (bwa)
$bwa_index $home/$reference

#Create sequence dictionary (picard)
java -Xmx8g -jar $home/$create_dictionary REFERENCE=$home/$reference OUTPUT=$home/$dictionary_output

#Create fasta index (samtools)
$samtools_faidx $home/$reference

