#!/usr/bin/python

import sys, re, getopt, os, subprocess, string

def main(argv):

    #get arguments
    try:
        opts, args = getopt.getopt(
            argv,
            "hb:r:g:t:",
            ["bam=", "ref=", "gatk=", "temp"])
    except getopt.GetoptError:
        print 'bam2vcf.py ' + \
                '-b <BAM file> ' + \
                '-r <reference> ' + \
                '-g <gatk> ' + \
                '-t <temp_dir>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'bam2vcf.py ' + \
                    '-b <BAM file> ' + \
                    '-r <reference> ' + \
                    '-g <gatk> ' + \
                    '-t <temp_dir>'
            sys.exit()
        elif opt in ("-b", "--bamfile"):
            bam = arg
        elif opt in ("-r", "--reference"):
            reference = arg
        elif opt in ("-g", "--gatk"):
            gatk = arg
        elif opt in ("-t", "--temp_dir"):
            temp_dir = arg
               
    vcf = bam.replace('bam', 'vcf')
    
    subprocess.call(['java', '-Xmx8g',
            '-Djava.io.tmpdir=' + temp_dir,
            '-jar', gatk,
            '-T', 'UnifiedGenotyper',
            '-R', reference,
            '-I', bam,
            '-o', vcf,
            '-glm', 'BOTH',
            '-mbq', '20',
            '-gt_mode', 'DISCOVERY',
            '-out_mode', 'EMIT_ALL_SITES',
            '-nt', '8'])
    
if __name__ == "__main__":
    main(sys.argv[1:])
