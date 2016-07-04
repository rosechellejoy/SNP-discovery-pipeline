#!/usr/bin/perl -w
use strict;

my $file=$ARGV[0];
my $disk=$ARGV[1];
my $analysis_dir="/home/rosechelle.oraa/analysis";
my $input_dir="/home/rosechelle.oraa/input";
my $reference="/home/rosechelle.oraa/reference/chrM.fa";
my $scripts_dir="/home/rosechelle.oraa/scripts";
my $output_dir="/home/rosechelle.oraa/scratch2/output";
my $gatk="/home/rosechelle.oraa/software/GenomeAnalysisTK-3.2-2/GenomeAnalysisTK.jar";
my $temp_dir="/home/rosechelle.oraa/scratch2/tmp";
my $genome="";

open FILE, $file or die $!;
while (my $line=readline*FILE){
	$line=~/(.*):(.*)/;
	$genome=$1;
	
	my $outfile="$analysis_dir/$disk/$genome/$genome"."-bam2vcf.slurm";

	my $execute="$analysis_dir/$disk/submit_bam2vcf_slurm.sh";
	open EXE, ">>", $execute or die $!;
	print EXE "#!/bin/bash\n";
	print EXE "sbatch $outfile\n";
	print EXE "sleep 10m\n";
	close EXE;

	open OUT, ">", $outfile or die $!;
	print OUT "#!/bin/bash\n";
	print OUT "\n";
	print OUT "#SBATCH -J ".$genome."-bam2vcf\n";
	print OUT "#SBATCH -o ".$genome."-bam2vcf.%j.out\n";
	print OUT "#SBATCH --partition=batch\n";
	print OUT "#SBATCH -e ".$genome."-bam2vcf.%j.error\n";
	print OUT "#SBATCH --mail-user=rosechellejoyoraa\@gmail.com\n";
	print OUT "#SBATCH --mail-type=begin\n";
	print OUT "#SBATCH --requeue\n";
	#print OUT "#SBATCH -N 3\n";
	print OUT "\n";
	print OUT "module load python/2.7.11\n";
	print OUT "module load jdk\n";
	print OUT "\n";
	print OUT "python $scripts_dir/bam2vcf.py -b $output_dir/$genome/*.merged.bam -r $reference -g $gatk -t $temp_dir";
	close OUT;
}
close FILE;	
