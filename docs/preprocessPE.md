# preprocessPE

`preprocessPE` runs a paired-end RNA-seq preprocessing workflow:

1. FastQC on raw reads
2. Trimmomatic adapter/quality trimming
3. fastp poly-G/poly-X trimming
4. FastQC on trimmed reads
5. MultiQC reports
6. RSEM/STAR reference preparation
7. STAR mapping
8. RSEM gene quantification

## Input FASTQ names

The workflow expects paired-end files named like:

```text
{sample}{lane}_{reads}1.fastq.gz
{sample}{lane}_{reads}2.fastq.gz
```

With the default config:

```yaml
lane: ""
reads: "R"
fq: ".fastq.gz"
```

sample `sample1` should have:

```text
sample1_R1.fastq.gz
sample1_R2.fastq.gz
```

## Config

Edit `config/configPreprocessPE.yaml`.

By default, `preprocessPE` loads:

```text
config/configPreprocessPE.yaml
```

To run with another config file without editing the workflow:

```bash
SEQWORKFLOWS_CONFIG=config/my_dataset.yaml snakemake -s preprocessPE -n
```

With the conda environment used in this repo:

```bash
SEQWORKFLOWS_CONFIG=config/my_dataset.yaml conda run -n snakemake snakemake -s preprocessPE -n
```

Minimal example:

```yaml
samples: "sample1 sample2 sample3"
lane: ""
reads: "R"
fq: ".fastq.gz"

step_qC: qC/
step_map: map/
step_counts: counts/

adapters: "TruSeq3-PE-2.fa"
threads: 10
strandedness: "reverse"

base_dir: /path/to/project/output/
raw_data_dir: /path/to/fastq/
trimmed_dir: /path/to/project/output/trimmed/

ref_genome: /path/to/genome.fa
gtf_file: /path/to/annotation.gtf
gtf_gff: "--gtf"

rsemprepref: /path/to/project/output/reference/rsemRef/
prefix_ref: "reference"
```

## Strandedness

Set `strandedness` according to the library preparation:

```yaml
strandedness: "unstranded"
```

Available values:

```text
unstranded -> RSEM --forward-prob 0.5
forward    -> RSEM --forward-prob 1
reverse    -> RSEM --forward-prob 0
```

Common Illumina stranded RNA-seq kits are often reverse-stranded, but this must be checked from the library prep protocol.

## Dry Run

From the repository root:

```bash
conda run -n snakemake snakemake -s preprocessPE -n
```

If Snakemake is active in your shell:

```bash
snakemake -s preprocessPE -n
```

## Wrapper Command

You can also run the paired-end workflow without manually editing a config file:

```bash
bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --sample sample1 \
  --threads 10 \
  --jobs 4 \
  --strandedness reverse
```

To call it as `seqworkflow` from anywhere, add the repository `bin/` directory to your `PATH`:

```bash
export PATH="/path/to/seqWorkflows/bin:$PATH"
```

The wrapper creates:

```text
OUTDIR/input/
OUTDIR/config/preprocessPE.yaml
OUTDIR/trimmed/
OUTDIR/reference/rsemRef/
```

It symlinks the input FASTQs into `OUTDIR/input/` using the naming convention expected by the Snakefile.

For a dry-run:

```bash
bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --dry-run
```

If `snakemake` is only available through conda, pass the executable explicitly:

```bash
bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --snakemake "conda run -n snakemake snakemake" \
  --dry-run
```

## Run With Containers

On Linux/HPC with Apptainer:

```bash
apptainer build seqworkflows.sif containers/seqworkflows.def

bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --runtime apptainer \
  --container-image seqworkflows.sif \
  --jobs 10
```

On macOS with OrbStack:

```bash
scripts/build_orbstack.sh

docker run --rm -it -v "$PWD:/work" -w /work seqworkflows:latest \
  bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR \
    --ref-genome genome.fa \
    --gtf-file annotation.gtf \
    --runtime orbstack \
    --jobs 10
```

## Logs

Logs are written under the output directories:

```text
qC/logs/fastqcRaw/
qC/logs/trimmomatic/
qC/logs/fastp/
qC/logs/fastqcTrim/
qC/logs/multiqc.log
map/logs/star/
counts/logs/rsem/
```

## Container Recipe

A unified container recipe for this workflow is available in:

```text
containers/seqworkflows.def
containers/seqworkflows.Dockerfile
env/seqworkflows.yml
env/seqworkflows-linux-64.lock.yml
```

See `containers/README.md` for build commands.
