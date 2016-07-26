#!/usr/bin/python
import sys, getopt, subprocess, os, re
from subprocess import Popen

def main(argv):

    try:
        opts, args = getopt.getopt(
            argv,
            "hv:",
            ["vcffile="])
    except getopt.GetoptError:
        print 'vcfvalidator.py ' + \
                '-v <vcf file> ' + \
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'vcfvalidator.py ' + \
                    '-v <VCF file> '
            sys.exit()
        elif opt in ("-v", "--vcffile"):
            vcf = arg
    vcf = vcf.rstrip('\n')
    split_dir = re.search(r'(.*)/(.*)/(.*vcf.gz)', vcf, re.M)
    if split_dir:
        input_dir = split_dir.group(1)
        genome = split_dir.group(2)
        vcffile = split_dir.group(3)
    else:
        print "Nothing found!"

    vcf_dup = vcffile.replace('gz', 'duplicates')
    vcf_uniq = vcffile.replace('gz', 'uniq')
    out = open(output_dir + '/'+ genome + vcf_dup, 'w')
    run = subprocess.call(['vcf-validator', '-d', vcf], stdout=out, stderr=subprocess.STDOUT)
    out2 = open(output_dir + '/' +genome + vcf_uniq, 'w')
    run = subprocess.call(['vcf-validator', '-u', vcf], stdout=out2, stderr=subprocess.STDOUT)
    print "Input:" + vcf

if __name__ == "__main__":
    main(sys.argv[1:])
