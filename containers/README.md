# Containers

This directory contains the unified container recipe for seqWorkflows.

The image is intended to be used in two ways:

1. Apptainer/Singularity on Linux or HPC, using Snakemake `container:` directives.
2. Docker/OrbStack on macOS, running the whole `seqworkflow` command inside the image.

Most active RNA-seq tools are installed from conda/bioconda:

- Snakemake
- FastQC
- Trimmomatic
- fastp
- MultiQC
- STAR
- RSEM
- samtools
- SRA tools
- Trinity
- Bowtie2
- BLAST+
- CD-HIT
- BUSCO
- TransDecoder
- HMMER
- Trinotate
- DESeq2 / GOseq

SignalP and Cell Ranger are not bundled because they usually require separate licensing or vendor downloads.

## Build With Apptainer

From the repository root:

```bash
apptainer build seqworkflows.sif containers/seqworkflows.def
```

Run a paired-end preprocessing dry-run and ask Snakemake to use the local SIF for each rule:

```bash
bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --runtime apptainer \
  --container-image seqworkflows.sif \
  --dry-run
```

Older Snakemake/Singularity setups can use:

```bash
bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --runtime singularity \
  --container-image seqworkflows.sif \
  --dry-run
```

## Build With Docker / OrbStack

With OrbStack running on macOS:

```bash
scripts/build_orbstack.sh
```

The script uses `docker` from `PATH` when available, or OrbStack's bundled Docker CLI at `/Applications/OrbStack.app/Contents/MacOS/xbin/docker`. By default it builds `linux/amd64`, which is the most reliable target for the Bioconda stack on Apple Silicon.

Run the CLI inside the container:

```bash
docker run --rm -it \
  -v "$PWD:/work" \
  -w /work \
  seqworkflows:latest \
  bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR \
    --ref-genome genome.fa \
    --gtf-file annotation.gtf \
    --runtime orbstack \
    --dry-run
```

In this mode, Snakemake runs inside the already-started container, so it does not need `--sdm apptainer`.

The Dockerfile and Apptainer definition install from `env/seqworkflows-linux-64.lock.yml`. The shorter `env/seqworkflows.yml` stays as the readable package recipe for updating the environment intentionally.
