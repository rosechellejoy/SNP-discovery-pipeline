#!/usr/bin/perl -w
use strict;

my $file=$ARGV[0];
my $disk=$ARGV[1];
my $analysis_dir="";
my $scripts_dir="";
my $output_dir="";
my $genome="";
my $email="";
my $partition="";
my $fp = 'config';

#get values from the config file
open my $info, $fp or die "Could not open $fp: $!";

while(my $line=<$info>){
	if($line =~ m/analysis_dir/){
		$analysis_dir=(split '=', $line)[-1];
		chomp($analysis_dir);
	}
	elsif($line =~ m/scripts_dir/){
		$scripts_dir=(split '=', $line)[-1];
		chomp($scripts_dir);
	}
	elsif($line =~ m/output_dir/){
		$output_dir=(split '=', $line)[-1];
		chomp($output_dir);
	}
	elsif($line =~ m/email/){
		$email=(split '=', $line)[-1];
		chomp($email);
	}
	elsif($line =~ m/partition/){
                $partition=(split '=', $line)[-1];
                chomp($partition);
        }
}

open FILE, $file or die $!;
while (my $line=readline*FILE){
	$line=~/(.*):(.*)/;
	$genome=$1;
	
	my $outfile="$analysis_dir/$disk/$genome/$genome"."-validatebam.slurm";

	my $execute="$analysis_dir/$disk/submit_validatebam_slurm.sh";
	open EXE, ">>", $execute or die $!;
	print EXE "#!/bin/bash\n";
	print EXE "sbatch $outfile\n";
	print EXE "sleep 10m\n";
	close EXE;
	
	open OUT, ">", $outfile or die $!;
	print OUT "#!/bin/bash\n";
	print OUT "\n";
	print OUT "#SBATCH -J ".$genome."-validatebam\n";
	print OUT "#SBATCH -o ".$genome."-validatebam.%j.out\n";
	print OUT "#SBATCH --cpus-per-task=3\n";	
	print OUT "#SBATCH --partition=$partition\n";
	print OUT "#SBATCH -e ".$genome."-validatebam.%j.error\n";
	print OUT "#SBATCH --mail-user=$email\n";
	print OUT "#SBATCH --mail-type=begin\n";
	print OUT "#SBATCH --mail-type=end\n";
	print OUT "#SBATCH --requeue\n";
	print OUT "\n";
	print OUT "module load bamutil/1.0.13-gcc \n";
	print OUT "\n";
	print OUT "python $scripts_dir/bamvalidator.py -b $output_dir/*merged.bam -o $output_dir\n";
	print OUT "mv $genome-mergebam*.error $genome-mergebam.*.out $analysis_dir/$disk/$genome/logs";
	close OUT;
}
close FILE;
