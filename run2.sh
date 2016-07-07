#!/bin/bash
conf=`grep -n "analysis_dir" config`
analysis_dir=${conf##*=}
conf=`grep -n "disk" config`
disk=${conf##*=}
filename="input.info"

dep=$(sbatch format_reference.sh)

#Alignment
perl createAlignmentSlurm.pl $filename $disk
while read -r line		#each line in input.info
do
	IFS=':' read -ra info <<< "$line" #split
		
    	for job in `ls $analysis_dir/$disk/$info/*fq2sam.* `
		do	#per read pairing
			a=$(sbatch --dependency=afterok:${dep##* } $job)
			dep=$a
		done	
	 
done < "$filename"

#sam to bam
perl createBAMProcessingSlurm.pl $filename $disk
while read -r line
do
	IFS=':' read -ra info <<< "$line" #split
        
       for job in `ls $analysis_dir/$disk/$info/*sam2bam.* `
                do      #per read pairing
                        a=$(sbatch --dependency=afterok:${dep##* } $job)
                        dep=$a
                done

done < "$filename"

#merge bam
perl createMergeBAMSlurm.pl $filename $disk
while read -r line
do
       IFS=':' read -ra info <<< "$line" #split
       a=$(sbatch --dependency=afterok:${dep##* } $analysis_dir/$disk/$info/*mergebam.*)
       dep=$a

done < "$filename"

#bam to vcf
perl createBAMtovcfslurm.pl $filename $disk
while read -r line
do
       IFS=':' read -ra info <<< "$line" #split
       a=$(sbatch --dependency=afterok:${dep##* } $analysis_dir/$disk/$info/*bam2vcf.*)
       dep=$a
                
done < "$filename"