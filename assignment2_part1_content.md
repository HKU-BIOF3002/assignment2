# Assignment 2: Variant calling pipeline

## Input data files

- FASTQ (Read1): `/home/groups/biof3002/week5/fastq/assignment2_demo.R1.fq.gz`
- FASTQ (Read2): `/home/groups/biof3002/week5/fastq/assignment2_demo.R2.fq.gz`

## Reference Files

- Reference genome (hg38): `/home/groups/biof3002/week5/ref/reference_genome/hg38/hg38.fa`
- Target regions: `interval_list=/home/groups/biof3002/week5/ref/targets/targets.hg38.interval_list`
- Databases of known polymorphic sites for `gatk BaseRecalibrator`
  - `known_snp=/home/groups/biof3002/week5/ref/gatk/Homo_sapiens_assembly38.dbsnp138.vcf`
  - `known_indel=/home/groups/biof3002/week5/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz`
- Databases for GATK Mutect2:
  - `germline_resource=/home/groups/biof3002/week5/ref/gatk/af-only-gnomad.hg38.vcf.gz` #Mutect2
  - `variant_vcf=/home/groups/biof3002/week5/ref/gatk/small_exac_common_3.hg38.vcf.gz` #Mutect2 GetPileupSummaries
- Database for snpEff:
  - `snpEff_config=/home/groups/biof3002/ref/annotation/snpEff/snpEff.config`
  - `snpEff_db=/home/groups/biof3002/ref/annotation/snpEff/data/`
- Database for ANNOVAR:
  - `annovar_db=/home/groups/biof3002/ref/annotation/ANNOVAR/humandb/`

## Pipeline architecture

### [Part 1](./assignment2_part1_guideline.md)

- [Step 1: Adaptor and quality trimming](./assignment2_part1_guideline.md#step-1-adaptor-and-quality-trimming)
- [Step 2: Alignment to reference genome](./assignment2_part1_guideline.md#step-2-alignment-to-reference-genome)
- [Step 3: Mark duplicates](./assignment2_part1_guideline.md#step-3-mark-duplicates)
- [Step 4: Base Quality Score Recalibration (BQSR)](./assignment2_part1_guideline.md#step-4-base-quality-score-recalibration-bqsr)
- [Step 5: Quality control](./assignment2_part1_guideline.md#step-5-quality-control)

### Part 2

- Step 6: Variant calling using Mutect2
- Step 7: Variant calling using VarScan

### Part 3

- [Step 8: Consensus variant calling](./guideline-consensus-variant-calling.md)
- [Step 9: Variant annotation](./guideline-variant-annotation.md)
