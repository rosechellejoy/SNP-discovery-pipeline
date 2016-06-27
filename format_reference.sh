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

#Index reference (bwa)
$home/$bwa $home/$reference

#Create sequence dictionary (picard)
java -Xmx8g -jar $home/$create_dictionary REFERENCE=$home/$reference OUTPUT=$home/$dictionary_output

#Create fasta index (samtools)
$home/$samtools_faidx $home/$reference
