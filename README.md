# :dna: Workflows for analysis of sequencing data


> **Warning**
>  To run this workflow it is necessary to have [snakemake](https://snakemake.github.io) and [Singularity](https://sylabs.io/) installed on the computer.



  **First of all, set the file *config.yaml* with the name of your samples, directories and other settings.**

  **Command to run:**

```snakemake -s <WORKFLOW_NAME> -j <N_OF_JOBS> --use-singularity --singularity-args "-B <DATA_DIRECTORY>" ```



*It is also possible to create new workflows just combining rules by including in the main Snakefile.*



## Quality control

```snakemake -s qC[SE/PE] -j <N_OF_JOBS> --use-singularity --singularity-args "-B <DATA_DIRECTORY>" ```

  This workflow will create the quality control report with the raw data individually and also the merged report. It will trim adapters and bases with bad quality and then generates reports for the trimmed data.

  - fastqc
  - trimmomatic
  - fastqc
  - multiqc

## RNAseq preprocessing

  This workflow will perform the quality control steps and then, align the reads to a reference genome/transcriptome using STAR and creating the count matrix using RSEM.

```snakemake -s preprocess[SE/PE] -j <N_OF_JOBS> --use-singularity --singularity-args "-B <DATA_DIRECTORY>" ```

  - STAR
  - RSEM

## De novo transcriptome assembly

```snakemake -s denovo[SE/PE] -j <N_OF_JOBS> --use-singularity --singularity-args "-B <DATA_DIRECTORY>" ```

### Assembly

  - trinity - assembly
  - busco - checking quality
  - cdhit - remove redundance
  
### Annotation ([Trinotate pipeline](https://rnabio.org/module-07-trinotate/0007/02/01/Trinotate/))

  - TransDecoder
  - Blastp & blastx against uniprot
  - signalP
  - HMMSCAN
  - trinotate
  
### Differential Expression Analysis

  - align and estimate abundance (RSEM)
  - abundance to matrix
  - run DE analysis
  
### GOSeq

  - create files needed
  - run GOSeq analysis
  
  
## Download public data using SRA-tools
  
  - prefetch
  - fastq-dump
