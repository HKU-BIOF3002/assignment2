# Contents

1. [Adaptor and quality trimming](#step-1-adaptor-and-quality-trimming)
2. [Alignment to reference genome](#step-2-alignment-to-reference-genome)
3. [Mark duplicates](#step-3-mark-duplicates)
4. [Base quality score recalibration](#step-4-base-quality-score-recalibration-bqsr)
5. [Quality control](#step-5-quality-control)
6. [Variant calling using Mutect2](#step-6-variant-calling-using-mutect2)
7. [Variant calling using VarScan2](#step-7-variant-calling-using-varscan2)
8. [Ensemble variant calling](#step-8-ensemble-variant-calling-mutect2--varscan)
9. [Variant annotation](#step-9-variant-annotation)

# Variant calling pipeline - Section 1

## Step 1: Adaptor and quality trimming

**Tools**:

- Trim_Galore (automate Cutadapt and FastQC)
- Cutadapt (adapter removal)
- FastQC (quality control reports)

**Expected output**:

- Trimmed FASTQ files: `assignment2_demo.R1_val_1.fq.gz`, `assignment2_demo.R2_val_2.fq.gz`
- Trimming reports: `assignment2_demo.R1.fq.gz_trimming_report.txt`, `assignment2_demo.R2.fq.gz_trimming_report.txt`
- FastQC reports: `assignment2_demo.R1_val_1_fastqc.zip`, `assignment2_demo.R1_val_1_fastqc.html`, `assignment2_demo.R2_val_2_fastqc.zip`, `assignment2_demo.R2_val_2_fastqc.html`

## Step 2: Alignment to reference genome

**Tools**:

- BWA-MEM (mapping DNA sequences against reference genome)
- samtools (BAM file processing)

**Implementation guide**:

- Use `bwa mem` for alignment with multiple threads (Suggested threads: 4)
- Add read group information (@RG tags) since this is crucial for subsequent GATK analysis. Check the option for `bwa mem` to add read group. 
- Convert SAM to BAM format and sort by coordinate using `samtools sort`
- Index the bam file using `samtools index`

**Expected output**:

- Sorted aligned BAM file and its index file: `assignment2_demo.RG.bam`, `assignment2_demo.RG.bam.bai`

## Step 3: Mark duplicates

**Tools**:

- MarkDuplicates (Picard)

**Implementation guide**:

- Use `gatk MarkDuplicates` to mark duplicated reads
- Create index for the output BAM file

**Expected output**:

- BAM file with duplicates marked and its index file: `assignment2_demo.MD.bam`, `assignment2_demo.MD.bam.bai` / `assignment2_demo.MD.bai`
- Duplication metrics file: `assignment2_demo.MD.stat`

## Step 4: Base Quality Score Recalibration (BQSR)

**Tools**:

- GATK BaseRecalibrator
- GATK ApplyBQSR

**Implementation guide**:

BQSR is a two-step process:

1. Use `gatk BaseRecalibrator` to enerates recalibration table for Base Quality Score Recalibration (BQSR).

   - Key parameters:
     - `--known-sites`: Databases of known polymorphic sites used to exclude regions around known polymorphisms from analysis.
       - Suggested databases: `/home/groups/biof3002/week5/ref/gatk/Homo_sapiens_assembly38.dbsnp138.vcf` and `/home/groups/biof3002/week5/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz`
     - `--interval-padding` or `-ip`: Amount of padding (in bp) to add to each interval you are including.
       - Suggested value: 10

2. Use `gatk ApplyBQSR` to apply base quality score recalibration.

**Expected output**:

- BAM file with base quality score recalibrated and its index file: `assignment2_demo.MD_BR.bam`, `assignment2_demo.MD_BR.bam.bai`/`assignment2_demo.MD_BR.bai`

## Step 5: Quality control

**Tools**:

- `bamtools stats`
- `gatk CollectMultipleMetrics`
- `gatk CollectReadCounts`
- `gatk CollectHsMetrics`

**Implementation guide**:

- Perform QC analysis using the above tools.

**Expected output**:

- `bamtools stats`:
  - `assignment2_demo.QC.bamtools_stat.txt`
- `gatk CollectMultipleMetrics`:
  - `assignment2_demo.QC.multiple_metrics.alignment_summary_metrics`
  - `assignment2_demo.QC.multiple_metrics.read_length_histogram.pdf`
  - `assignment2_demo.QC.multiple_metrics.base_distribution_by_cycle_metrics`
  - `assignment2_demo.QC.multiple_metrics.base_distribution_by_cycle.pdf`
  - `assignment2_demo.QC.multiple_metrics.insert_size_metrics`
  - `assignment2_demo.QC.multiple_metrics.insert_size_histogram.pdf`
  - `assignment2_demo.QC.multiple_metrics.quality_by_cycle_metrics`
  - `assignment2_demo.QC.multiple_metrics.quality_by_cycle.pdf`
  - `assignment2_demo.QC.multiple_metrics.quality_distribution_metrics`
  - `assignment2_demo.QC.multiple_metrics.quality_distribution.pdf`
- `gatk CollectReadCounts`
  - `assignment2_demo.QC.read_counts.tsv`
- `gatk CollectHsMetrics`
  - `assignment2_demo.QC.hs_metrics.txt`

# Variant calling pipeline - Section 2

## Step 6: Variant calling using Mutect2

### Variant calling using Mutect2

**Tools**:

- `gatk Mutect2`
- `gatk LearnReadOrientationModel`
- `gatk GetPileupSummaries`
- `gatk CalculateContamination`
- `gatk FilterMutectCalls`

**Implementation guide**:

- Perform Mutect2 variant calling in accordance with Week 7 instructions

**Expected output**:

- `gatk Mutect2`
  - `assignment2_demo.Mutect2.f1r2.tar.gz`
  - `assignment2_demo.Mutect2.unfiltered.vcf`
- `gatk LearnReadOrientationModel`
  - `assignment2_demo.Mutect2.read-orientation-model.tar.gz`
- `gatk GetPileupSummaries`
  - `assignment2_demo.Mutect2.getpileupsummaries.table`
- `gatk CalculateContamination`
  - `assignment2_demo.Mutect2.calculatecontamination.table`
- `gatk FilterMutectCalls`
  - `assignment2_demo.Mutect2.filter1.vcf`

### Filtering Mutect2 results

**Tools**:

- `bcftools norm`
- `bcftools filter`
- `tabix`

**Implementation guide**:

- Implement bcftools norm command to split multiallelic sites and perform left normalization
- Implement bcftools filter command to filter the variants
- Use tabix to index the resulting VCF files

**Expected output**:

- `bcftools norm`
  - `assignment2_demo.Mutect2.filter1.norm.vcf.gz`
- `bcftools filter`
  - `assignment2_demo.Mutect2.final.vcf.gz`

## Step 7: Variant calling using VarScan2

### Variant calling using VarScan2

**Tools**:

- `samtools mpileup`
- `java -jar /software/VarScan/2.4.2/VarScan.jar mpileup2snp`
- `java -jar /software/VarScan/2.4.2/VarScan.jar mpileup2indel`
- `tabix`

**Implementation guide**:

- Perform VarScan2 variant calling on SNP and indel in accordance with Week 7 instructions

**Expected output**:

- `samtools mpileup`
- `java -jar /software/VarScan/2.4.2/VarScan.jar mpileup2snp`
  - `assignment2_demo.varscan.snp.vcf.gz`
- `java -jar /software/VarScan/2.4.2/VarScan.jar mpileup2indel`
  - `assignment2_demo.varscan.indel.vcf.gz`

### Normalizing VarScan2 results

**Tools**:

- `bcftools norm`
- `tabix`

**Implementation guide**:

- Implement bcftools norm command to split multiallelic sites and perform left normalization
- Use tabix to index the resulting VCF files

**Expected output**:

- `bcftools norm`
  - `assignment2_demo.varscan.snp.norm.vcf.gz`
  - `assignment2_demo.varscan.indel.norm.vcf.gz`

# Variant calling pipeline - Section 3

# Ensemble variant calling

## Step 8: Ensemble variant calling (Mutect2 + VarScan)

**Overview**: We will generate a **ensemble variant call** set by merging results from **Mutect2** and **VarScan**. You will standardize VCF formats from both callers and then combine them info a single file for downstream analysis.

We will use `bcftools` for manipulating VCF files and `tabix` for indexing VCF files. Before starting, load these modules:

## Step 8.1: Format VCF from Mutect2

### Step 8.1.1: Extract GT and AD fields

Mutect2 outputs a VCF with many INFO fields and data fields. We will create a simplified VCF containing only:

- **GT**: genotype
- **AD**: allele depth (reference depth, alternate depth).

**Implementation guide**:

- Use `bcftools annotate -x` to remove all **INFO** fields and keep only **GT** and **AD** format fields.
- Output should be compressed VCF format.
- Index the result VCF file.

**Expected output**:

- `${sample}.Mutect2.final.GT_AD.vcf.gz` with corresponding `.tbi` index

Example VCF data line:

   ```text
   #CHROM  POS             ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  assignment2_demo
   chr1    114716123       .       C       T       .       PASS    .       GT:AD   0|1:413,11
   ```

### Step 8.1.2: Rename sample in VCF header

Rename the sample in VCF header to identify Mutect2 calls after merging.

**Implementation guide**:

- Use `bcftools reheader` to rename the sample.
- The new name shoule be `${sample}_Mutect2`.
- Index the renamed file.

**Expected output**:

- `${sample}.Mutect2.final.GT_AD.rename.vcf.gz` with corresponding `.tbi` index

Example VCF data file:

   ```text
   #CHROM  POS             ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  assignment2_demo_Mutect2
   chr1    114716123       .       C       T       .       PASS    .       GT:AD   0|1:413,11
   ```

## Step 8.2 Format VCF from VarScan

### Step 8.2.1 Extract RD(ref depth) and AD (allele depth) from VCF, and convert it to match Mutect2's AD format structure

VarScan outputs a VCF with many INFO fields and data fields. For ensemble calling, we need:

- **GT**: genotype
- **RD**: reference depth
- **AD**: alternate depth

Note that the VCF from Mutect2 and VarScan have different representation for reference depth and alternate depth. We will convert VarScan's output to match Mutect2's AD format structure.

**Implementation guide**:

- a) Create minimal header file from the Mutect2 VCF
  - Use `bcftools view -h` and `grep` to extract:
    - fileformat line
    - GT definition
    - AD definition
    - column header line
  - Save to a temporoary text file for subsequent use.
- b) Reformat SNP data
  - Use `bcftools query -f` with custom formatting of data lines.
  - You need to output the data lines in the format of data lines in VCF file (i.e., CHROM, POS, ID, REF, ALT, QUAL, FILTER, INFO, FORMAT and sample data).
  - Format: GT:AD
  - Combine **RD** and **AD** in original VarScan's output into **AD** field.
  - Save to a temporoary text file for subsequent use.
- c) Rebuild VCF
  - Use `cat` to combine the file created in Step a and b.
  - Use `bgzip` for compression.
  - Index the final file.

Repeat step b and c for indel data.

**Expected output**:

- `${sample}.varscan.snp.final.GT_AD.vcf.gz` with corresponding `.tbi` index
- `${sample}.varscan.indel.final.GT_AD.vcf.gz` with corresponding `.tbi` index

Example data lines:

   ```text
   #CHROM  POS             ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  assignment2_demo
   chr11   118480320       .       CT      C       .       PASS    .       GT:AD   0/1:217,9
   ```


### Step 8.2.2 Rename sample name in VCF header

Rename the sample in VCF header to identify VarScan calls after merging.

**Implementation guide**:

- Rename SNP VCF sample to `${sample}_VarScan_snp`
- Reanme indel VCF sample to `${sample}_VarScan_indel`

**Expected output**:

- `${sample}.varscan.snp.final.GT_AD.rename.vcf` with corresponding `.tbi` index

Example data line:

  ```text
  #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  assignment2_demo_VarScan_snp
  chr1    36473693        .       T       C       .       PASS    .       GT:AD   1/1:0,432
  ```

- `${sample}.varscan.indel.final.GT_AD.rename.vcf` with corresponding `.tbi` index

Example data line:

   ```text
   #CHROM  POS             ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  assignment2_demo_VarScan_indel
   chr11   118480320       .       CT      C       .       PASS    .       GT:AD   0/1:217,9
   ```

### Step 8.3: Merge formatted VCF from Mutect2 and VarScan

Build a VCF containing variants from all variant callers.

**Implementation guide**:

- Use `bcftools merge` to combine formatted Mutect2, VarScan SNP and VarScan indel calls.
- Option `-m none` to avoid multiallelic record is suggested.
- Output compressed VCF file.
- Index the final merged file.

**Expected output**:

- `${sample}.merged.vcf.gz` with corresponding `.tbi` index

Example output VCF for ensemble variant calling:

   ```text
   #CHROM  POS       ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  assignment2_demo_Mutect2      assignment2_demo_VarScan_snp  assignment2_demo_VarScan_indel
   chr1    36473693  .       T       C       .       PASS    .       GT:AD   ./.:.                    1/1:0,432              ./.:.
   chr1    43338496  .       G       A       .       PASS    .       GT:AD   ./.:.                    0/1:160,142            ./.:.
   ```

# Variant annotation

We will annotate our ensemble variants using **snpEff** and **ANNOVAR**.

## Step 9: Variant annotation

### Step 9.1: snpEff

Before starting, load the required modulues:

### Step 9.1.1: Run snpEff annotations

Annotate variants with snpEff.

**Implementation guide**:

- Run `snpEff` on the merged VCF file using `java -jar  /software/snpEff/5.1/snpEff.jar` with appropriate parameters.
  - Key parameters:
    - Custom database: `hg38_biof3002_32genes_MANE_RefSeq`
    - Configuration file: `${snpEff_config}`
    - Database directory: `${snpEff_db}`

**Expected output**:

- Annotated VCF: `${sample}.snpEff.vcf.gz`
- Statistics output: `${sample}.snpEff.stat.html`

### Step 9.1.2:Extract key snpEff annotations

Create a tab-delimited file with specific annotation fields from snpEff.

**Implementation guide**:

- SnpSift `extractFields` can extract specific ANN fields.
  - Handle missing values using `-e "."`.
  - The `-s ","` parameter helps with field separation.
  - Fields to extract:
    - Standand VCF fields (CHROM, POS, ID, REF, ALT)
    - GENE
    - FEATUREID
    - HGVS_C
    - HGVS_P

**Expected output**: `${sample}.snpEff.txt`
Example data:

```text
CHROM   POS             ID      REF     ALT     ANN[*].GENE     ANN[*].FEATUREID        ANN[*].HGVS_C           ANN[*].HGVS_P
chr1    36473693        .       T       C       CSF3R           NM_000760.4             c.485+71A>G             .
chr11   32396399        .       T       C       WT1             NM_024426.6             c.1122A>G               p.Arg374Arg
chr12   22661102        .       A       G       ETNK1,ETNK1     NM_018638.4,NM_018638.5 c.864A>G,c.597A>G       p.Glu288Glu,p.Glu199Glu
```

### Step 9.2: ANNOVAR

Annotate variants with multiple databases using ANNOVAR.

**Implementation guide**:

- Load the required module: `module load ANNOVAR/2020Jun08`
- Run `table_annovar.pl` on the merged VCF
  - Database to include: refGene,cytoBand,avsnp150,esp6500siv2_all,ALL.sites.2015_08,AFR.sites.2015_08,AMR.sites.2015_08,EAS.sites.2015_08,EUR.sites.2015_08,SAS.sites.2015_08,exac03nontcga,gnomad30_genome,clinvar_20250721,intervar_20180118,kaviar_20150923,dbnsfp35a,dbscsnv11,hrcr1,regsnpintron,cosmic92
  - Database directory: `${annovar_db}`
  - Build version: `hg38`
  - The `--protocol` parameter lists the databases to use
  - The `--operation` paramteter lists the operation type [`g` (gene-based), `r` (region-based) or `f` (filtered-based)] of each protocol
  - Missing data handling: `--nastring .`
  - Clean up temporary files: `--remove`

**Expected output**:

- `${sample}.hg38_multianno.vcf`
- `${sample}.hg38_multianno.txt`

### Step 9.3: Merge annotations from snpEff and ANNOVAR (Optional?)

**Script**:

```bash
source /home/groups/biof3002/variant_calling/env/py3.9/bin/activate
python $(dirname $0)/merge_annotation.py ${sample}.snpEff.txt  ${sample}.hg38_multianno.txt  > ${sample}.snpEff_annovar.txt
```
