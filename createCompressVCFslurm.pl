e strict;

my $file=$ARGV[0];
my $disk=$ARGV[1];
my $output_dir="";
my $analysis_dir="";
my $disk="";
my $email="";
my $genome="";

open FILE, $file or die $!;
while (my $line=readline*FILE){
        $line=~/(.*):(.*)/;
        $genome=$1;
        my $outfile="$analysis_dir/$disk/$genome/$genome"."-bgzip.slurm";

        open OUT, ">", $outfile or die $!;
        print OUT "#!/bin/bash\n";
        print OUT "\n";
        print OUT "#SBATCH -J ".$genome."-bgzip\n";
        print OUT "#SBATCH -o ".$genome."-bgzip.%j.out\n";
        print OUT "#SBATCH --partition=batch\n";
        print OUT "#SBATCH -e ".$genome."-bgzip.%j.error\n";
        print OUT "#SBATCH --mail-user=$email\n";
        print OUT "#SBATCH --mail-type=begin\n";
        print OUT "#SBATCH --requeue\n";
        #print OUT "#SBATCH -N 3\n";
        print OUT "\n";
        print OUT "bgzip $output_dir/$genome/*.vcf";
        close OUT;
        }
close FILE;
