# README #

#Instructions on how to use the SNP Discovery Pipeline:

1.	create the following folders:
	-> scripts
	-> output
	-> input **containing all the input reads
	-> reference **containing the reference genome
	-> analysis

2. 	have a copy of the scripts needed by cloning the repository
	https://github.com/rosechellejoy/SNP-discovery-pipeline	

3.	modify the values in the "config" text file.

4. 	modify the values in input.info and enumerate all the input genomes with the number or reads e.g(IRIS_313-10519:12) 
    **one genome per line

5.  On the scripts folder, enter "sbatch snp.sh" on the command line.
