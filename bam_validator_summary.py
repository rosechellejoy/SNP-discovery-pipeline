#!/usr/bin/python

import sys, os, re, getopt

def main(argv):

    directory = ''

    try:
        opts, args = getopt.getopt(argv, "hd:", ["dir="])
    except getopt.GetoptError:
        print 'bamstat_summary.py -d <directory>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'bamstat_summary.py -d <directory>'
            sys.exit()
        elif opt in ("-d", "--dir"):
            directory = arg

    from os import listdir
    from os.path import isfile, join
    statfiles = [ f for f in listdir(directory) if isfile(join(directory,f)) ]
    statfiles.sort()
    
    out_dir = directory.replace('validation','analysis')
    output = open(out_dir + '/' + 'bam_validator_summary.txt','w') 
    heading = 'Number of records read\tNumber of valid records\tTotalReads(e6)\tMappedReads(e6)\tPairedReads(e6)\t' + \
                'ProperPair(e6)\tDuplicateReads(e6)\tQCFailureReads(e6)\tMappingRate(%)\t' + \
                'PairedReads(%)\tProperPair(%)\tDupRate(%)\t' + \
                'QCFailRate(%)\tTotalBases(e6)\t' + \
                'BasesInMappedReads(e6)\n'
    output.write(heading)
    
    #extract values from each stats file
    delimiter = '\t' 
    for file in statfiles:
        fail = open(directory + '/' + file).read()
        if 'FAIL' in fail:
            file = file.replace('.txt', '')
            file = file + '\tFAIL\n'
            #output.write(file)
	else:
            stat = open(directory + '/' + file).readlines()
            file = file.replace(".realigned","")
            file = file.replace(".merged","")
            file = file.replace('05_DJ123_','')
            file = file.replace('04_Kasalath_','')
            file = file.replace('03_9311_','')
            file = file.replace('01_Nipponbare_', '')

            #print stat
            records_read = stat[1].replace('Number of records read =','').rstrip('\n')
            valid_records = stat[2].replace('Number of valid records =','').rstrip('\n')
            total_reads = stat[4].replace('TotalReads(e6)','').rstrip('\n')
            mapped_reads = stat[5].replace('MappedReads(e6)','').rstrip('\n')
            paired_reads = stat[6].replace('PairedReads(e6)','').rstrip('\n')
            proper_pair = stat[7].replace('ProperPair(e6)','').rstrip('\n')
            duplicate_reads = stat[8].replace('DuplicateReads(e6)','').rstrip('\n')
            qc_failure_reads = stat[9].replace('QCFailureReads(e6)','').rstrip('\n')
            mapping_rate_pct = stat[11].replace('MappingRate(%)','').rstrip('\n')
            paired_reads_pct = stat[12].replace('PairedReads(%)','').rstrip('\n')
            proper_pair_pct = stat[13].replace('ProperPair(%)','').rstrip('\n')
            dup_rate_pct = stat[14].replace('DupRate(%)','').rstrip('\n')
            qc_fail_rate_pct = stat[15].replace('QCFailRate(%)','').rstrip('\n')
            total_bases = stat[17].replace('TotalBases(e6)','').rstrip('\n')
            bases_in_mapped_reads = stat[18].replace('BasesInMappedReads(e6)','')
        
            file = file.replace( '.txt', '')
            out = [file, records_read, valid_records, 
                total_reads, mapped_reads, 
                paired_reads, proper_pair, duplicate_reads,
                qc_failure_reads, mapping_rate_pct,
                paired_reads_pct, proper_pair_pct,
                dup_rate_pct, qc_fail_rate_pct,
                total_bases, bases_in_mapped_reads]
            output_data = ('\t'.join((str(x) for x in out)))
            output.write(output_data)

            #output.write('\t'.join(str(x) for x in out))
        
if __name__ == "__main__":
    main(sys.argv[1:])
