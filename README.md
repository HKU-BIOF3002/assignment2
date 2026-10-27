# BIOF3002 Assignment 2

**Due date:** Nov 27<sup>th</sup>, 2026 (Friday) 23:59

**Marks:** 35% of total assessment

## Introduction

As a clinical bioinformatician, one of the key skills required is creating and maintaining data analysis pipelines with version control. This assignment will be divided into two related parts,

1.  Build a variant calling pipeline based on what you have learned in the lectures.

2.  Use this pipeline to analyse and report the mutations of a given patient's NGS sample.

## Initialisation Instructions

-  Do not clone or fork this repository directly. Follow these steps to create your own copy:

      1. Sign into your GitHub account if you haven't already.
      2. **Create your repository:** Click the **"Use this template"** button at the top right of this page and select **"Create a new repository"**.
      3. **Configure settings:** 
         * Set the Repository name (in the format of: `assignment-2-yourname`).
         * Choose **Private** (so other students cannot copy your work).
         * Click **"Create repository from template"**.
      4. **Add Ip Ho Wan (iphowan) as a collaborator:** Under **Settings** in the repository, click on **Collaborators**, then click "Add people" and search for the user iphowan.
      5. To prepare to clone a private directory to CPOS HPCF3, you must first setup a [Personal Access Token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) in GitHub.
      6. **Clone to CPOS HPCF3:** Go to your newly created repository page, click the **Code** button, copy the URL. Navigate to an appropriate directory under your home folder and run this in the terminal:
         ```bash
         git clone <YOUR-NEW-REPOSITORY-URL>
         ```
         Follow the prompts to enter your GitHub username and the PAT as the password from step v.
         

## Submission Instructions

**Part 1** will involve updating your pipeline over 3 weeks on the Feedback branch of your Assignment 2 GitHub repository.

**Part 2** will involve the generation of a clinical report based on the fastq file, i.e. `assignment2_aml.R1.fq.gz` and `assignment2_aml.R2.fq.gz`, which will be provided to you after the Week 9 lecture.

The clinical report (as a PDF file) should be submitted via Moodle by the Due Date. In your GitHub repository, you should commit your updated functional pipeline and the final annotated variant table (as a tsv file).

If you make further commits to the repository after the due date, a late penalty of -10% (-3.5 marks) per day will apply.

## Detailed Instructions for Part 1

During the lecture/workshops from Week 5 to Week 9, you should have gone through the key steps for NGS-based variant calling. Your task is to distil the steps shown/discussed in the lectures and code this into a single shell script. A skeleton shell script `NGS_pipeline.sh` has been provided for you, and you are to update and commit this script before the due date, based on the demonstration fastq files, i.e. `assignment2_demo.R1.fq.gz` and `assignment2_demo.R2.fq.gz`, from a patient with acute myeloid leukaemia.

Detailed instructions for Part 1 can be found in this [guideline](./assignment2_part1_guideline.md). The location of the fastq files for demo practice and the reference files are listed in this [webpage](./assignment2_part1_content.md) for your easy reference. **Please note that the provided reference files in this assignment are abridged versions, so do not use the reference files for analysis apart from this assignment.**

## Detailed Instructions for Part 2

Run your final pipeline on the NGS data from a patient newly diagnosed to have acute myeloid leukaemia, i.e. `/home/groups/biof3002/assignment2/fastq/assignment2_aml.R1.fq.gz` and `/home/groups/biof3002/assignment2/fastq/assignment2_aml.R2.fq.gz`. Your task is to call variants from the NGS data, perform variant curation and write a clinical genomic report based on the genomic results. The format of the clinical genomic report has been illustrated in Week 10-11 Case 3. For the conclusion of the report, remember to focus on any diagnostic/prognostic/therapeutic implications of your curated variants. Apart from the mentioned references in the workshop, you may need to look up further references to develop better understanding of the curated variants. You only need to work on single nucleotide variants and short indels (i.e. less than 21 bp). Specifically, you do not need to worry about FLT3-internal tandem duplication.

## Use of Generative AI

-   There is *no* restriction on the use of generative AI, such as GitHub CoPilot, to assist you with the code. 

-   However, as a clinical bioinformatician, it is imperative that you have good understanding of your submitted codes. Also, you bear the sole responsibility of reviewing the codes (and parameters) and ensuring your codes are functioning and to the purpose.

