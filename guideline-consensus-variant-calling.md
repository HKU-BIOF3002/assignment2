# Consensus variant calling

## Step 8: Consensus variant calling (Mutect2 + VarScan)

**Overview**: We will generate a **consensus variant call** set by merging results from **Mutect2** and **VarScan**. You will standardize VCF formats from both callers and then combine them info a single file for downstream analysis.

We will use `bcftools` for manipulating VCF files and `tabix` for indexing VCF files. Before starting, load these modules:

```bash
module load bcftools/1.20 tabix/1.13
```

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
   #CHROM  POS             ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  21H2000158
   chr1    114716123       .       C       T       .       PASS    .       GT:AD   0|1:413,11
   ```

**Script**:

```bash
bcftools annotate -x INFO,^FORMAT/GT,^FORMAT/AD ${sample}.Mutect2.final.vcf.gz -O z -o ${sample}.Mutect2.final.GT_AD.vcf.gz
tabix -p vcf ${sample}.Mutect2.final.GT_AD.vcf.gz
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
   #CHROM  POS             ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  21H2000158_Mutect2
   chr1    114716123       .       C       T       .       PASS    .       GT:AD   0|1:413,11
   ```

**Script**:

```bash
echo ${sample}_Mutect2 | bcftools reheader -s - ${sample}.Mutect2.final.GT_AD.vcf.gz -o ${sample}.Mutect2.final.GT_AD.rename.vcf.gz
tabix -p vcf ${sample}.Mutect2.final.GT_AD.rename.vcf.gz
```

## Step 8.2 Format VCF from VarScan

### Step 8.2.1 Extract RD(ref depth) and AD (allele depth) from VCF, and convert it to match Mutect2's AD format structure

VarScan outputs a VCF with many INFO fields and data fields. For consensus calling, we need:

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
   #CHROM  POS             ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  21H2000158
   chr11   118480320       .       CT      C       .       PASS    .       GT:AD   0/1:217,9
   ```

**Scripts**:

```bash
bcftools view -h ${sample}.Mutect2.final.GT_AD.vcf.gz |grep "fileformat\|ID=GT\|ID=AD\|CHROM" > ${sample}.varscan.minimal_vcf_header.txt

bcftools query -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%QUAL\t%FILTER\t.\tGT:AD\t[%GT:%RD,%AD]\n' ${sample}.varscan.snp.norm.vcf.gz > ${sample}.varscan.snp.data.txt 
cat ${sample}.varscan.minimal_vcf_header.txt ${sample}.varscan.snp.data.txt | bgzip -c >  ${sample}.varscan.snp.final.GT_AD.vcf.gz
tabix -p vcf ${sample}.varscan.snp.final.GT_AD.vcf.gz

bcftools query -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%QUAL\t%FILTER\t.\tGT:AD\t[%GT:%RD,%AD]\n' ${sample}.varscan.indel.norm.vcf.gz > ${sample}.varscan.indel.data.txt 
cat ${sample}.varscan.minimal_vcf_header.txt ${sample}.varscan.indel.data.txt | bgzip -c > ${sample}.varscan.indel.final.GT_AD.vcf.gz
tabix -p vcf ${sample}.varscan.indel.final.GT_AD.vcf.gz
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
  #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  21H2000158_VarScan_snp
  chr1    36473693        .       T       C       .       PASS    .       GT:AD   1/1:0,432
  ```

- `${sample}.varscan.indel.final.GT_AD.rename.vcf` with corresponding `.tbi` index

Example data line:

   ```text
   #CHROM  POS             ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  21H2000158_VarScan_indel
   chr11   118480320       .       CT      C       .       PASS    .       GT:AD   0/1:217,9
   ```

**Scripts**:

```bash
echo ${sample}_VarScan_snp |  bcftools reheader -s - ${sample}.varscan.snp.final.GT_AD.vcf.gz -o ${sample}.varscan.snp.final.GT_AD.rename.vcf.gz
tabix -p vcf ${sample}.varscan.snp.final.GT_AD.rename.vcf.gz

echo ${sample}_VarScan_indel |  bcftools reheader -s - ${sample}.varscan.indel.final.GT_AD.vcf.gz -o ${sample}.varscan.indel.final.GT_AD.rename.vcf.gz
tabix -p vcf ${sample}.varscan.indel.final.GT_AD.rename.vcf.gz
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

Example output VCF for consensus variant calling:

   ```text
   #CHROM  POS       ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  21H2000158_Mutect2      21H2000158_VarScan_snp  21H2000158_VarScan_indel
   chr1    36473693  .       T       C       .       PASS    .       GT:AD   ./.:.                    1/1:0,432              ./.:.
   chr1    43338496  .       G       A       .       PASS    .       GT:AD   ./.:.                    0/1:160,142            ./.:.
   ```

**Scripts**:

```bash
bcftools merge -m none ${sample}.Mutect2.final.GT_AD.rename.vcf.gz ${sample}.varscan.snp.final.GT_AD.rename.vcf.gz ${sample}.varscan.indel.final.GT_AD.rename.vcf.gz -O z -o ${sample}.merged.vcf.gz
tabix -p vcf ${sample}.merged.vcf.gz
```
