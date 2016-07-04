#!/usr/bin/perl -w
use strict;

my $file=$ARGV[0];
my $disk=$ARGV[1];
my $analysis_dir="/home/rosechelle.oraa/analysis";
my $input_dir="/home/rosechelle.oraa/input";
my $reference_dir="/home/rosechelle.oraa/reference";
my $scripts_dir="/home/rosechelle.oraa/scripts";
my $output_dir="/home/rosechelle.oraa/scratch2/output";
my $genome="";

open FILE, $file or die $!;
while (my $line=readline*FILE){
	$line=~/(.*):(.*)/;
	$genome=$1;

	my $outfile="$analysis_dir/$disk/$genome/$genome"."-mergebam.slurm";

	my $execute="$analysis_dir/$disk/submit_mergebam_slurm.sh";
	open EXE, ">>", $execute or die $!;
	print EXE "#!/bin/bash\n";
	print EXE "sbatch $outfile\n";
	print EXE "sleep 10m\n";
	close EXE;
	
	open OUT, ">", $outfile or die $!;
	print OUT "#!/bin/bash\n";
	print OUT "\n";
	print OUT "#SBATCH -J ".$genome."-mergebam\n";
	print OUT "#SBATCH -o ".$genome."-mergebam.%j.out\n";	
	print OUT "#SBATCH --partition=batch\n";
	print OUT "#SBATCH -e ".$genome."-mergebam.%j.error\n";
	print OUT "#SBATCH --mail-user=rosechellejoyoraa\@gmail.com\n";
	print OUT "#SBATCH --mail-type=begin\n";
	print OUT "#SBATCH --mail-type=end\n";
	print OUT "#SBATCH --requeue\n";
	#print OUT "#SBATCH -N 3\n";
	print OUT "\n";
	print OUT "module load samtools/1.0-intel\n";
	print OUT "\n";
	print OUT "perl $scripts_dir/mergebam.pl $output_dir $genome";
	close OUT;
}
close FILE;
