# Assignment 2: Variant calling pipeline

## Input data files

- FASTQ for Part 1 (Read1): `/home/groups/biof3002/assignment2/fastq/assignment2_demo.R1.fq.gz`
- FASTQ for Part 1 (Read2): `/home/groups/biof3002/assignment2/fastq/assignment2_demo.R2.fq.gz`

## Reference files

- Reference genome (hg38): `/home/groups/biof3002/week9/ref/reference_genome/hg38/hg38.fa`
- Target regions: `interval_list=/home/groups/biof3002/week9/ref/targets/targets.hg38.interval_list`
- Databases of known polymorphic sites for `gatk BaseRecalibrator`
  - `known_snp=/home/groups/biof3002/week9/ref/gatk/Homo_sapiens_assembly38.dbsnp138.vcf`
  - `known_indel=/home/groups/biof3002/week9/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz`
- Databases for GATK Mutect2:
  - `germline_resource=/home/groups/biof3002/week9/ref/gatk/af-only-gnomad.hg38.vcf.gz` #Mutect2
  - `variant_vcf=/home/groups/biof3002/week9/ref/gatk/small_exac_common_3.hg38.vcf.gz` #Mutect2 GetPileupSummaries
- Database for snpEff:
  - `snpEff_config=/home/groups/biof3002/week9/ref/annotation/snpEff/snpEff.config`
  - `snpEff_db=/home/groups/biof3002/week9/ref/annotation/snpEff/data/`
- Database for ANNOVAR:
  - `annovar_db=/home/groups/biof3002/week9/ref/annotation/ANNOVAR/humandb/`

## Software versions

```bash
module load ANNOVAR/2020Jun08
module load bamtools/2.5.1
module load bcftools/1.20 tabix/1.13
module load bwa/0.7.17
module load cutadapt/1.8.1
module load FastQC/0.12.1
module load gatk/4.6.0.0
module load java/12.0.2 snpEff/5.1 tabix/1.13
module load samtools/1.20
module load samtools/1.20 java/8.0_161 VarScan/2.4.2 tabix/1.13
module load TrimGalore/0.4.5
```

## Pipeline architecture

### [Part 1](./assignment2_part1_guideline.md#variant-calling-pipeline---section-1)

- [Step 1: Adaptor and quality trimming](./assignment2_part1_guideline.md#step-1-adaptor-and-quality-trimming)
- [Step 2: Alignment to reference genome](./assignment2_part1_guideline.md#step-2-alignment-to-reference-genome)
- [Step 3: Mark duplicates](./assignment2_part1_guideline.md#step-3-mark-duplicates)
- [Step 4: Base Quality Score Recalibration (BQSR)](./assignment2_part1_guideline.md#step-4-base-quality-score-recalibration-bqsr)
- [Step 5: Quality control](./assignment2_part1_guideline.md#step-5-quality-control)

### [Part 2](./assignment2_part1_guideline.md#variant-calling-pipeline---section-2)

- [Step 6: Variant calling using Mutect2](./assignment2_part1_guideline.md#step-6-variant-calling-using-mutect2)
- [Step 7: Variant calling using VarScan](./assignment2_part1_guideline.md#step-7-variant-calling-using-varscan2)

### [Part 3](./assignment2_part1_guideline.md#variant-calling-pipeline---section-3)

- [Step 8: Ensemble variant calling](./assignment2_part1_guideline.md#step-8-ensemble-variant-calling-mutect2--varscan)
- [Step 9: Variant annotation](./assignment2_part1_guideline.md#step-9-variant-annotation)
