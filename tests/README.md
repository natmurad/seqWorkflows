# Tests

Run the lightweight CLI test suite:

```bash
python3 tests/test_seqworkflow_cli.py
```

These tests do not require Snakemake. They pass `/usr/bin/true` as the Snakemake executable and verify that `seqworkflow` creates the expected config files, input symlinks, generated Trinity DE files, and command-line options for each supported mode.

For full validation, run each mode with `--dry-run` in an environment where Snakemake is installed:

```bash
seqworkflow preprocessPE R1.fastq.gz R2.fastq.gz OUTDIR --ref-genome genome.fa --gtf-file annotation.gtf --dry-run
```
