#!/bin/bash
conf=`grep -n "analysis_dir" config`
analysis_dir=${conf##*=}
conf=`grep -n "disk" config`
disk=${conf##*=}
conf=`grep -n "input_dir" config`
input_dir=${conf##*=}
filename="input.info"
inc_pairs=false

#check if read pairs are complete
while read -r line
do
        IFS=':' read -ra info <<< "$line" #split, get each genome
        for pair in `ls $input_dir/$info/*1.fq.gz`
		do
			pair2=${pair/1.fq.gz/2.fq.gz}
			if [ ! -f $pair2 ]
			then
				echo "$pair does not have a pair"
				inc_pairs=true
			fi
		done
done < "$filename"
 
while read -r line
do
        IFS=':' read -ra info <<< "$line" #split, get each genome
        for pair in `ls $input_dir/$info/*2.fq.gz`
                do
                       pair2=${pair/2.fq.gz/1.fq.gz}
                       if [ ! -f $pair2 ]
                       then
				
                                echo "$pair does not have a pair"
                       		inc_pairs=true
                       fi
                done
done < "$filename"

if [ "$inc_pairs" = true ]
then
	exit $
fi

format=$(sbatch format_reference.sh)

perl createAlignmentSlurm.pl $filename $disk
perl createBAMProcessingSlurm.pl $filename $disk
perl createMergeBAMSlurm.pl $filename $disk
perl createBAMtovcfslurm.pl $filename $disk

while read -r line
do
	IFS=':' read -ra info <<< "$line" #split, get each genome

	for job in `ls $analysis_dir/$disk/$info/*fq2sam.* `
                do      #per read pair
			#submit *fq2sam. to the job scheduler, set format reference as its dependency
                        dep=$(sbatch --dependency=afterok:${format##* } $job)
                        samtobam=${job/fq2sam./sam2bam.}
			#submit its corresponding sam2bam to the job scheduler w/ fq2sam as its dependency
			sbatch --dependency=afterok:${dep##* } $samtobam
                done
done < "$filename"

while read -r line
do
	IFS=':' read -ra info <<< "$line" #split, get each genome

        for job in `ls $analysis_dir/$disk/$info/*mergebam.* `
                do      #per read pair
                        #submit *mergebam. to the job scheduler, set all sam2bam as its dependency
                        dep=$(sbatch --dependency=singleton $job)
                        bamtovcf=${job/mergebam./bam2vcf.}
                        #submit its corresponding bam2vcf to the job scheduler w/ mergebam as its dependency
                        sbatch --dependency=afterok:${dep##* } $bamtovcf
                done
done < "$filename"
	

