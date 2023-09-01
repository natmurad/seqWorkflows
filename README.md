# :dna: Workflows for preprocessing sequencing data [![DOI](https://zenodo.org/badge/617594074.svg)](https://zenodo.org/badge/latestdoi/617594074)


> **Warning**
>  To run this workflow it is necessary to have [snakemake](https://snakemake.github.io) and [Singularity](https://sylabs.io/) installed on the computer.


## Files needed to run the pipeline

  - Raw fastq.gz files or SRA list
  
 **Map to reference**
 
  - Reference and gff file downloaded from ENSEMBL.
 
 **De novo assembly**
 
  - *sample_file.txt* and *constrast_file.txt* (drafts in the folder data) :arrow_right: it must be located on the input directory.


## Running

  **First of all, set the file *config.yaml* with the name of your samples, directories and other settings.**
  
> **Warning**
> Do not forget of change the name of the samples and directories in the config.yaml file



  **Command to run:**

```snakemake -s <WORKFLOW_NAME> -j <N_OF_JOBS> --use-singularity --singularity-args "-B <DATA_DIRECTORY>" ```



*It is also possible to create new workflows just combining rules by including in the main Snakefile.*

## Step-by-step

:ballot_box_with_check: You have snakemake and singularity installed and running

:ballot_box_with_check: You have the folder with the fastq files or the Sra Acc List

:ballot_box_with_check: You have the Contrast and sample files *(only if using de novo assembly)*

:ballot_box_with_check: Clone this repository on your computer

:ballot_box_with_check: Edit config file with your pathways

:ballot_box_with_check: Edit the config file path (1st line) on the file of the chosen pipeline


## Download public data using SRA-tools

```snakemake -s sra -j <N_OF_JOBS> --use-singularity --singularity-args "-B <DATA_DIRECTORY>" ```

 These rules can be included in the workflow if you want to start it from the SRA list. It will download the files and perform the fastq-dump step to generate the fastq files.
  
  - prefetch
  - fastq-dump

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
  
## Genome-guided transcriptome assembly

```snakemake -s refguided[SE/PE] -j <N_OF_JOBS> --use-singularity --singularity-args "-B <DATA_DIRECTORY>" ```
  
### Sort alignment
  
  - RSEM
  - STAR
  - samtools

### Guided assembly

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
