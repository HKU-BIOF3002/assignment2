#!/bin/bash
#--------------------------------------------------------------
# Assignment 2 NGS script
# Name:
# UID:
#--------------------------------------------------------------

set -euo pipefail

if [ $# -ne 2 ];then 
	echo "Usage: $0 <sample> <fasta>"
	exit 1
fi 

# specific default sample and reference fasta
#sample=
#fasta=

sample=$1
fasta=$2

# setup default paths for relevant files required for the pipeline
#fq1=                                      #read1
#fq2=                                      #read2
#interval_list=                            #Targeted sequencing intervals
#known_snp=                                #BaseRecalibrator
#known_indel=                              #BaseRecalibrator
#germline_resource=                        #Mutect2
#variant_vcf=                              #Mutect2 GetPileupSummaries
#CPU=                                      #threads to use

#--------------------------------------------------------------
# Alignment (Due 24th Oct) 
#--------------------------------------------------------------
# Trimming


# Alignment
## BWA


# BAM post-processing
## Add ReadGroup to bam since this is required in GATK processing

## Mark duplicates

## BQSR

# QC  


#--------------------------------------------------------------
# Varinat calling (Due 31st Oct)
#--------------------------------------------------------------
# Variant calling using Mutect2

# Filtering Mutect2 results
## Normalize VCF 

## Filtering: VAF>=0.02; DP>=200; POPAF>2

## Extract INFO and AD(ref depth, alt_depth) from VCF


# Variant calling using Varscan (Criteria:coverage>=200, VAF>=0.035)


# Filtering VarScan results
## Normalize VCF

## Extract RD(ref depth) and AD (allele depth) from VCF, and convert it into the same format of AD in Mutect2





#--------------------------------------------------------------
# Consensus variant calling (Mutect2, VarScan) (Due 14th Nov)
#--------------------------------------------------------------
# Rename VCF header

# Merge VCF from Mutect2 and VarScan
## -m none: does not allow multiallelic record

