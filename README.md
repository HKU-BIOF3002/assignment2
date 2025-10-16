# BIOF3002 Assignment 2

**Due date:** Dec 5<sup>th</sup>, 2025 (Friday) 23:59

**Marks:** 10 + 25 (35% of total assessment)

## Introduction

As a clinical bioinformatician, one of the key skills required is creating and maintaining data analysis pipelines. This assignment will be divided into two parts,

1.  Build a variant calling pipeline based on what you have learn in the lectures.

2.  Use this pipeline to analyse and report on the mutations of a given patient's NGS sample.

## Submission instructions

**Part 1** will involve updating your pipeline over 3 weeks on the Feedback branch of your Assignment 2 GitHub repository. The schedule for updating your pipeline is as follows:

-   Fri 24<sup>th</sup> Oct 2025, 23:59 - NGS alignment, BAM preparation, and generation of alignment metrics. (3 marks)

-   Fri 31<sup>st</sup> Oct 2025, 23:59 - Variant calling using Mutect2 and Varscan 2. (3 marks)

-   Fri 14<sup>th</sup> Nov 2025, 23:59 - Merging VCF (4 marks)

At each deadline, you would need to have committed your updated pipeline to the Feedback branch and additionally provide some brief comments on what you did in the Pull Request in the Feedback branch.


**Part 2** will involve the generation of a clinical report based on the fastq file, which you will be provided after the Week 7 lecture.

This report is to be committed to the Main Branch by the Due Date as either part of README.md or as a separate PDF file in the repository.

If you make further commits to the repository after the due date, a late penalty of -10% (-2.5 marks) per day will apply.

## Detailed instructions for Part 1

During the lecture/workshops from Week 5 to Week 7, you would have gone through the key steps for NGS-based variant calling. Your task is to distill the steps shown and discussed in the lectures and code this into a single shell script. A skeleton shell script `NGS_script.sh` has been provided for you, and you are to update and commit this script on the respective due dates. As such, for the first commit (24th Oct), you are to implement the pipeline for NGS alignment, BAM preparation and alignment metrics generation based on what was taught in Week 5 (for short read NGS alignment), etc.

Full marks for that week will be given for any reasonable attempt at building the pipeline for that week. We will provide feedback (if necessary) to correct/improve your pipeline.

## Detailed instructions for Part 2

TBC



