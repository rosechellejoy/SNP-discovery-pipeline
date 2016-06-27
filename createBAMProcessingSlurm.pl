#!/usr/bin/perl -w
use strict;

#define variables
my $file=$ARGV[0]; #input file containing genome: fastq pair count  (eg. IRIS_313-9939: 12)
my $disk=$ARGV[1]; #directory of the fastq files (eg. 07)
my $analysis_dir="/home/rosechelle.oraa/scripts/bam_processing";
my $input_dir="/home/rosechelle.oraa/scratch2/output";
my $reference_dir="/home/rosechelle.oraa/reference/chrM.fa";
my $scripts_dir="/home/rosechelle.oraa/scripts";
my $output_dir="/home/rosechelle.oraa/scratch2/output";
my $picard="/home/rosechelle.oraa/software/picard-tools-1.119";
my $gatk="/home/rosechelle.oraa/software/GenomeAnalysisTK-3.2-2/GenomeAnalysisTK.jar";
my $jvm="8g";
my $tmp_dir="/home/rosechelle.oraa/scratch2/tmp";
my $genome="";
my $count="";


open FILE, $file or die $!;
while (my $line=readline*FILE){
	$line=~/(.*):(.*)/; #get the genome/accession/variety name and the fastq pair count
	$genome=$1;
	$count=$2;
	$count=$count/2; #divide by half to get variable for job array limit

	#make individual directory for each genome and put slurm script in that directory
	system("mkdir $analysis_dir/$disk/$genome");
	my $outfile="$analysis_dir/$disk/$genome/$genome"."-sam2bam.slurm";
	
	#create a submit shell script containing the slurm script for each genome
	#with a sleep of 60s in between job submission to prevent timeout
	my $execute="$analysis_dir/$disk/submit_sam2bam_slurm.sh";
	open EXE, ">>", $execute or die $!;
	print EXE "sbatch $outfile\n";
	print EXE "sleep 10m\n";
	close EXE;
	
	#create the slurm script for each genome
	open OUT, ">", $outfile or die $!;
	print OUT "#!/bin/bash\n";
	print OUT "\n";
	print OUT "#SBATCH -J ".$genome."-sam2bam\n";
	print OUT "#SBATCH -o ".$genome."-sam2bam.%j.out\n";
	print OUT "#SBATCH --cpus-per-task=6\n"; #use this for multithreading 	
	print OUT "#SBATCH --array=1-".$count."\n";
	print OUT "#SBATCH --partition=batch\n";
	print OUT "#SBATCH -e ".$genome."-sam2bam.%j.error\n";
	print OUT "#SBATCH --mail-user=j.detras\@irri.org\n";
	print OUT "#SBATCH --mail-type=begin\n";
	print OUT "#SBATCH --mail-type=end\n";
	print OUT "#SBATCH --requeue\n";
	print OUT "\n";
	print OUT "module load python\n";
	print OUT "module load jdk\n";
	print OUT "\n";
	#get the first pair of a fastq file and assign for use
	print OUT "filename=`find $input_dir/$disk/$genome -name \"*.sam\" | tail -n +\${SLURM_ARRAY_TASK_ID} | head -1`\n";
	print OUT "\n";
	#execute the command
	print OUT "python $scripts_dir/sam2bam.py -s \$filename -r $reference_dir -p $picard -g $gatk -j $jvm -t $tmp_dir";
	close OUT;
}
close FILE;
