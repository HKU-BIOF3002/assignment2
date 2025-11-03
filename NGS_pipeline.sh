#!/bin/bash
#--------------------------------------------------------------
# Assignment 2 NGS script
# Name:
# UID:
#--------------------------------------------------------------

set -euo pipefail

if [ $# -ne 2 ];then 
	echo "Usage: $0 <sample> <Reference genome (fasta)>"
	exit 1
fi 

# Input sample name and fasta of reference genome from command line arguments
sample=$1
fasta=$2

# Setup default paths for relevant files/parameters required for the pipeline
#fq1=                                      #read1
#fq2=                                      #read2
#interval_list=                            #Targeted sequencing intervals
#known_snp=                                #BaseRecalibrator
#known_indel=                              #BaseRecalibrator
#germline_resource=                        #Mutect2
#variant_vcf=                              #Mutect2 GetPileupSummaries
#CPU=                                      #threads to use

#---------------------------------------------------------------------
# Section 1: Trim, alignment, mark duplicates, BQSR, QC (Due 7th Nov)
#---------------------------------------------------------------------

# --- Step 1: Adaptor and quality trimming ---"


# --- Step 2: Alignment to reference genome ---


# --- Step 3: Mark duplicates ---


# --- Step 4: Base Quality Score Recalibration (BQSR) ---


# --- Step 5: Quality control ---
## TODO: Implement bamtools stats command

## TODO: Implement gatk CollectMultipleMetrics command

## TODO: Implement gatk CollectReadCounts command

## TODO: Implement gatk CollectHsMetrics command


#-----------------------------------------------------------
# Section 2: Variant calling (Due 14th Nov)
#-----------------------------------------------------------

# --- Step 6: Variant calling using Mutect2 ---
## Variant calling using Mutect2


## Filtering Mutect2 results
### TODO: Normalize VCF 

### TODO: Filtering: VAF>=0.02; DP>=200; POPAF>2


# --- Step 7: Variant calling using VarScan 2 ---
## Variant calling using VarScan 2 for both SNP and indel (Criteria: coverage >=200; VAF >=0.035)

## Normalize VarScan results


#---------------------------------------------------------------------------
# Section 3: Ensemble variant calling and variant annotation (Due 21st Nov)
#---------------------------------------------------------------------------

# --- Step 8: Ensemble variant calling ---
## Format VCF from Mutect2
### TODO: Extract GT and AD(reference depth, alternate depth) fields in VCF

### TODO: Rename sample in VCF header

## Format VCF from VarScan (repeat for both SNP and indel VCF files)
### TODO: Extract GT and AD(reference depth, alternate depth) fields in VCF

### TODO: Rename sample in VCF header

## Merge formatted VCF from Mutect2 and VarScan


# --- Step 9: Variant annotation ---
# Perform variant annotation using snpEff
## TODO: Run snpEff to annotate variants

## TODO: Extract key snpEff annotations into a tab-delimited file using SnpSift

# Perform variant annotation using ANNOVAR
## TODO: Run ANNOVAR to annotate variants

# Merge annotations from snpEff and ANNOVAR into a final tab-delimited file using the given merge_annotation.py script
## TODO: Run merge_annotation.py to merge snpEff and ANNOVAR annotations


# ------------------------------
# End of script
# ------------------------------
