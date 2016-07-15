#Instructions on how to use the SNP Discovery Pipeline:

1.	create the following folders: scripts, output, input, reference, analysis

2. 	have a copy of the scripts needed by cloning the repository https://github.com/rosechellejoy/SNP-discovery-pipeline	

3.	modify the values in the "config" text file.

4. 	modify the values in input.info and enumerate all the input genomes with the number of reads e.g(IRIS_313-10519:12) **one genome per line

5.  On the scripts folder, enter "sbatch snp.sh" on the command line.

6.  wait until all jobs have finished. You can check by entering "squeue -u < username >"

7.  After all jobs has finished, enter "sbatch log.sh" on the command line. This will produce a text file "log.txt" containing a list of all genomes that failed.
