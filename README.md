# seqWorkflows [![DOI](https://zenodo.org/badge/617594074.svg)](https://zenodo.org/badge/latestdoi/617594074)

Reusable Snakemake workflows for RNA-seq quality control, preprocessing, transcript quantification, de novo transcriptome assembly, and reference-guided assembly.

The recommended entry point is the `seqworkflow` command. It creates a run-specific config file, links FASTQs into the expected layout, and launches the selected Snakemake workflow. In normal use, you do not need to edit YAML config files by hand.

## Requirements

Choose one execution style:

- Local: Snakemake and all workflow tools installed on your machine.
- Apptainer: Apptainer plus the `seqworkflows.sif` image.
- OrbStack/Docker: OrbStack or Docker plus the `seqworkflows:latest` image.

## Quick Start

Add the repository command-line tools to your `PATH`:

```bash
export PATH="/path/to/seqWorkflows/bin:$PATH"
```

Show all modes and options:

```bash
seqworkflow --help
```

Run a paired-end reference preprocessing workflow:

```bash
seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz results/preprocessPE \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --sample sample1 \
  --threads 10 \
  --jobs 4 \
  --strandedness reverse
```

Run a dry-run first:

```bash
seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz results/preprocessPE \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --dry-run
```

`seqworkflows` also works as an alias, but `seqworkflow` is the preferred command name.

## Modes

| Mode | Input | Purpose |
| --- | --- | --- |
| `qcPE` | paired-end FASTQs | FastQC, trimming, fastp, MultiQC |
| `preprocessPE` | paired-end FASTQs + reference | QC, trimming, STAR, RSEM |
| `preprocessSE` | single-end FASTQ + reference | QC, trimming, STAR, RSEM |
| `denovoPE` | paired-end FASTQs | Trinity de novo assembly, annotation, abundance, DE/GO |
| `denovoSE` | single-end FASTQ | Trinity de novo assembly, annotation, abundance, DE/GO |
| `refguidedPE` | paired-end FASTQs + reference | STAR/RSEM, genome-guided Trinity, annotation, DE/GO |

## Supported Status

| Area | Status | Notes |
| --- | --- | --- |
| `seqworkflow` CLI | Supported | Creates per-run config and input symlinks for all listed modes |
| `qcPE` | Supported | Paired-end QC/trimming workflow; `qC_PE` remains a legacy alias |
| `preprocessPE` | Supported | Main paired-end reference workflow |
| `preprocessSE` | Supported | Main single-end reference workflow |
| `denovoPE` | Supported | Requires valid Trinity sample/contrast files for real DE analysis |
| `denovoSE` | Supported | Requires valid Trinity sample/contrast files for real DE analysis |
| `refguidedPE` | Supported | Paired-end reference-guided workflow |
| SRA rules | Experimental | Rule files are present, but not exposed as a top-level CLI mode yet |
| single-cell rules | Experimental | Cell Ranger is not bundled in the unified container |
| SignalP step | Optional/external | SignalP is not bundled because it usually requires separate licensing |

## Examples

Paired-end QC only:

```bash
seqworkflow qcPE R1.fastq.gz R2.fastq.gz results/qc \
  --sample sample1 \
  --jobs 4
```

Single-end preprocessing:

```bash
seqworkflow preprocessSE reads.fastq.gz results/preprocessSE \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --sample sample1 \
  --strandedness reverse
```

Paired-end de novo workflow:

```bash
seqworkflow denovoPE R1.fastq.gz R2.fastq.gz results/denovoPE \
  --sample sample1 \
  --sample-file sample_file.txt \
  --contrast-file contrast_file.txt \
  --jobs 4
```

Reference-guided paired-end workflow:

```bash
seqworkflow refguidedPE R1.fastq.gz R2.fastq.gz results/refguidedPE \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --sample sample1 \
  --sample-file sample_file.txt \
  --contrast-file contrast_file.txt
```

For mode-specific options:

```bash
seqworkflow preprocessPE --help
seqworkflow denovoPE --help
```

## Inputs

Minimum inputs:

- Raw FASTQ files: `.fastq.gz`, `.fq.gz`, `.fastq`, or `.fq`.
- Reference workflows: genome FASTA and annotation GTF/GFF.
- De novo and reference-guided workflows: `sample_file.txt` and `contrast_file.txt` for Trinity differential expression steps.

If `--sample-file` or `--contrast-file` is omitted for a de novo mode, `seqworkflow` creates a minimal placeholder file so the DAG can be built. For real differential expression analysis, pass proper sample and contrast files.

## Output Layout

Each run writes into the `OUTDIR` you provide:

```text
OUTDIR/
  config/                 generated YAML config for this run
  input/                  symlinks to input FASTQs using pipeline naming
  trimmed/                trimmed FASTQs
  qC/                     FastQC, fastp, MultiQC and logs
  map/                    STAR alignments
  counts/                 RSEM outputs and count matrices
  reference/rsemRef/      generated reference index, when needed
  assembly_trinity/       Trinity outputs, when needed
```

Actual subdirectories depend on the selected mode.

## Containers

The project has one unified container recipe:

```text
containers/seqworkflows.def
containers/seqworkflows.Dockerfile
env/seqworkflows.yml
env/seqworkflows-linux-64.lock.yml
```

`env/seqworkflows.yml` is the readable package recipe. `env/seqworkflows-linux-64.lock.yml` is the pinned Linux container lockfile exported from a successful build and used by the Docker/Apptainer recipes.

### Apptainer

Build:

```bash
apptainer build seqworkflows.sif containers/seqworkflows.def
```

Run:

```bash
seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz results/preprocessPE \
  --ref-genome genome.fa \
  --gtf-file annotation.gtf \
  --runtime apptainer \
  --container-image seqworkflows.sif
```

### OrbStack / Docker

Build with OrbStack or Docker running:

```bash
scripts/build_orbstack.sh
```

Run the workflow inside the image:

```bash
docker run --rm -it \
  -v "$PWD:/work" \
  -w /work \
  seqworkflows:latest \
  bin/seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz results/preprocessPE \
    --ref-genome genome.fa \
    --gtf-file annotation.gtf \
    --runtime orbstack
```

The build script uses `docker` if it is available in `PATH`. If not, it uses OrbStack's bundled Docker CLI at `/Applications/OrbStack.app/Contents/MacOS/xbin/docker`. The image is built as `linux/amd64` because Bioconda has broader package support there than on macOS ARM.

In OrbStack/Docker mode, Snakemake runs inside the already-started container. In Apptainer mode, Snakemake uses the configured container image for each rule.

SignalP and Cell Ranger are not bundled in the unified image because they usually require separate licensing or vendor downloads.

## Main Tools

- FastQC
- Trimmomatic
- fastp
- MultiQC
- STAR
- RSEM
- samtools
- Trinity
- Bowtie2
- BLAST+
- CD-HIT
- BUSCO
- TransDecoder
- HMMER
- Trinotate
- DESeq2 / GOseq

## Tests

Run the lightweight CLI tests:

```bash
python3 tests/test_seqworkflow_cli.py
```

These tests validate the command-line interface, generated configs, input symlinks, and per-mode wiring without requiring Snakemake. Full workflow validation still requires running `--dry-run` or real jobs in an environment with Snakemake and the workflow tools available.

## Advanced Usage

The generated config file is written to:

```text
OUTDIR/config/<mode>.yaml
```

For the QC mode, `qcPE` is the public CLI name and the legacy Snakefile/config name remains `qC_PE`.

You can still run Snakemake manually with a custom config:

```bash
SEQWORKFLOWS_CONFIG=config/my_dataset.yaml snakemake -s preprocessPE -j 4
```

Or with Apptainer through Snakemake:

```bash
SEQWORKFLOWS_CONFIG=config/my_dataset.yaml snakemake -s preprocessPE -j 4 --sdm apptainer
```

Detailed paired-end preprocessing documentation is available in [docs/preprocessPE.md](docs/preprocessPE.md). Container build notes are in [containers/README.md](containers/README.md). Recent project changes are summarized in [CHANGELOG.md](CHANGELOG.md).

## Development

Workflows are composed from rule files under:

```text
rules/PE/
rules/SE/
rules/BOTH/
rules/SRA/
rules/SINGLECELL/
```

New workflows can be built by composing existing rules in a top-level Snakefile.
