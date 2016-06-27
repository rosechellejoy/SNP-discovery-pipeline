#!/usr/bin/perl -w
use strict;

#define variables
my $file=$ARGV[0]; #input file containing genome: fastq pair count  (eg. IRIS_313-9939: 12)
my $disk=$ARGV[1]; #directory of the fastq files (eg. 07)
my $analysis_dir="/home/jeffrey.detras/slurm-scripts/mh63/alignment";
my $input_dir="/home/jeffrey.detras/IRRI";
my $reference_dir="/home/jeffrey.detras/reference/mh63/MH63RS1.LNNK00000000.fa";
my $scripts_dir="/home/jeffrey.detras/slurm-scripts/scripts";
my $output_dir="/home/jeffrey.detras/scratch2/rwing/mh63";
my $genome="";
my $count="";
my $string="";

opendir(DIR, ".");
my @files = grep(/1\.fq.gz$/,readdir(DIR));		#stores all 1.fq.gz in the current directory to an array
closedir(DIR);

foreach $file (@files) {	#for each file in files, 
   	$filepath = $file;				
	$filepath =~ s/1.fq.gz/2.fq.gz/ig;		#replace substring 1.fq.gz with 2.fq.gz

	if (-f $filepath)		#if $file 's pair does not exist
	{
	  print "$file does not have a pair"
	}
}



open FILE, $file or die $!;
while (my $line=readline*FILE){
	$line=~/(.*):(.*)/; #get the genome/accession/variety name and the fastq pair count
	$genome=$1;
	$count=$2;
	$count=$count/2; #divide by half to get variable for job array limit

	#make individual directory for each genome and put slurm script in that directory
	system("mkdir $analysis_dir/$disk/$genome");
	my $outfile="$analysis_dir/$disk/$genome/$genome"."-fq2sam.slurm";
	
	#create a submit shell script containing the slurm script for each genome
	#with a sleep of 60s in between job submission to prevent timeout
	my $execute="$analysis_dir/$disk/submit_slurm.sh";
	open EXE, ">>", $execute or die $!;
	print EXE "sbatch $outfile\n";
	print EXE "sleep 10m\n";
	close EXE;
	
	#create the slurm script for each genome
	open OUT, ">", $outfile or die $!;
	print OUT "#!/bin/bash\n";
	print OUT "\n";
	print OUT "#SBATCH -J ".$genome."-fq2sam\n";
	print OUT "#SBATCH -o ".$genome."-fq2sam.%j.out\n";
	#print OUT "#SBATCH -n 1\n";
	print OUT "#SBATCH --cpus-per-task=16\n"; #use this for multithreading 	
	print OUT "#SBATCH --array=1-".$count."\n";
	print OUT "#SBATCH --partition=batch\n";
	print OUT "#SBATCH -e ".$genome."-fq2sam.%j.error\n";
	print OUT "#SBATCH --mail-user=j.detras\@irri.org\n";
	print OUT "#SBATCH --mail-type=begin\n";
	print OUT "#SBATCH --mail-type=end\n";
	print OUT "#SBATCH --requeue\n";
	print OUT "\n";
	print OUT "module load python/2.7.10\n";
	print OUT "\n";
	#get the first pair of a fastq file and assign for use
	print OUT "filename=`find $input_dir/$disk/T11073/Fq/$genome -name \"*1.fq.gz\" | tail -n +\${SLURM_ARRAY_TASK_ID} | head -1`\n";
	print OUT "\n";
	#execute the command
	print OUT "python $scripts_dir/fq2sam.py -r $reference_dir -p \$filename -o $output_dir/$disk -t \$SLURM_CPUS_PER_TASK\n";
	close OUT;
}
close FILE;
