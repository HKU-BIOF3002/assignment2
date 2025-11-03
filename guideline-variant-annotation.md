# Variant annotation

We will annoate our consensus variants using **snpEff** and **ANNOVAR**.

## Step 9: Variant annotation

### Step 9.1: snpEff

Before starting, load the required modulues:

```bash
module load java/12.0.2 snpEff/5.1 tabix/1.13
```

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

**Script**:

```bash
java -jar  /software/snpEff/5.1/snpEff.jar -v -c ${snpEff_config} -dataDir ${snpEff_db} -stats ${sample}.snpEff.stat.html hg38_biof3002_32genes_MANE_RefSeq ${sample}.merged.vcf.gz | bgzip -c > ${sample}.snpEff.vcf.gz
```

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

**Script**:

```bash
zcat ${sample}.snpEff.vcf.gz | java -jar /software/snpEff/5.1/SnpSift.jar extractFields  -s ","  -e "." - CHROM POS ID REF ALT "ANN[*].GENE" "ANN[*].FEATUREID" "ANN[*].HGVS_C" "ANN[*].HGVS_P" > ${sample}.snpEff.txt

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

**Script**:

```bash
table_annovar.pl ${sample}.merged.vcf.gz ${annovar_db} --buildver hg38 -out ${sample}    \
 --protocol refGene,cytoBand,avsnp150,esp6500siv2_all,ALL.sites.2015_08,AFR.sites.2015_08,AMR.sites.2015_08,EAS.sites.2015_08,EUR.sites.2015_08,SAS.sites.2015_08,exac03nontcga,gnomad30_genome,clinvar_20250721,intervar_20180118,kaviar_20150923,dbnsfp35a,dbscsnv11,hrcr1,regsnpintron,cosmic92 \
 --operation g,r,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f   --remove     --nastring .     --vcfinput
```

### Step 9.3: Merge annotations from snpEff and ANNOVAR (Optional?)

**Script**:

```bash
source /home/groups/biof3002/variant_calling/env/py3.9/bin/activate
python $(dirname $0)/merge_annotation.py ${sample}.snpEff.txt  ${sample}.hg38_multianno.txt  > ${sample}.snpEff_annovar.txt
```
