#!/bin/bash

#SBATCH -J format_reference     
#SBATCH -o format_reference.%j.out   
#SBATCH -e format_reference.%j.error
#SBATCH --partition=batch
#SBATCH --mail-user=j.detras@irri.org
#SBATCH --mail-type=ALL
#SBATCH --requeue

home='/home/jeffrey.detras'
reference='reference/other/mh63/MH63_v1_pseudo.fa'
bwa_index='software/bwa-0.7.10/bwa index'
create_dictionary='software/picard-tools-1.119/CreateSequenceDictionary.jar'
samtools_faidx='software/samtools-1.0/samtools faidx'
dictionary_output='reference/other/mh63/MH63_v1_pseudo.dict'

#Index reference (bwa)
$home/$bwa $home/$reference

#Create sequence dictionary (picard)
java -Xmx8g -jar $home/$create_dictionary REFERENCE=$home/$reference OUTPUT=$home/$dictionary_output

#Create fasta index (samtools)
$home/$samtools_faidx $home/$reference
