#       Filename: mergebam.pl
#       Description: submits the command for merging bam files
#       Parameters: genome directory
#       Created by: Jeffrey Detras
#!/usr/bin/python

import sys, getopt, re, os, subprocess

def main(argv):

    #get arguments
    try:
        opts, args = getopt.getopt(
            argv,
            "hg:",
            ["genome_dir="])
    except getopt.GetoptError:
        print 'mergebam.py ' + \
                '-g <genome_dir> ' + \
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'mergebam.py ' + \
                    '-g <genome_dir> ' + \
            sys.exit()
        elif opt in ("-g", "--genome_dir"):
            genome_dir = arg
    
    genome = re.search(r'(.*)/(.*)$', genome_dir, re.M)
    if genome:
        genome = genome.group(2)
    mergedbam_output = genome_dir + '/' + genome + '.bam'
    
    mergebam = 'samtools merge ' + \
        mergedbam_output + ' ' + \
        genome_dir + '/*.realign.bam'\
    os.system(mergebam)

    subprocess.call(['samtools', 'index', mergedbam_output]) 

if __name__ == "__main__":
    main(sys.argv[1:])
