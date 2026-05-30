# Changelog

## Unreleased

### Added

- Added `seqworkflow` / `seqworkflows` CLI entry points.
- Added automatic per-run config generation under `OUTDIR/config/`.
- Added automatic FASTQ symlinking under `OUTDIR/input/`.
- Added CLI support for `preprocessPE`, `preprocessSE`, `qcPE`, `denovoPE`, `denovoSE`, and `refguidedPE`.
- Added strandedness parameterization for reference workflows.
- Added unified container recipes for Apptainer and Docker/OrbStack:
  - `containers/seqworkflows.def`
  - `containers/seqworkflows.Dockerfile`
  - `env/seqworkflows.yml`
- Added `scripts/build_orbstack.sh` to build the Docker image with OrbStack's bundled Docker CLI.
- Added pinned Linux container lockfile `env/seqworkflows-linux-64.lock.yml`.
- Standardized the preferred CLI name to `seqworkflow`; `seqworkflows` remains an alias.
- Added `qcPE` as the preferred QC mode name; `qC_PE` remains a legacy alias.
- Added lightweight CLI tests in `tests/test_seqworkflow_cli.py`.
- Added GitHub Actions CI for CLI tests and Python syntax checks.
- Added GHCR publication workflow for versioned container tags.
- Added SHA-256 reference manifests to prevent incompatible RSEM/STAR index reuse.
- Added paired-end `fastp` rule.
- Added documentation for CLI usage, containers, supported mode status, and tests.

### Changed

- Standardized workflow config loading with `SEQWORKFLOWS_CONFIG`.
- Standardized rule containers through `SEQWORKFLOWS_CONTAINER`.
- Replaced floating `latest` container references with `ghcr.io/natmurad/seqworkflows:1.0.0`.
- Updated paired-end and single-end QC, trimming, mapping, and quantification rules with logs, threads, and output directories.
- Updated README to focus on the command-line interface instead of manual config editing.

### Fixed

- Fixed paired-end naming consistency for raw, trimmed, fastp, STAR, and RSEM outputs.
- Fixed multiple Snakemake syntax issues in Trinity-related rules.
- Fixed YAML parsing issue in the reference-guided config.
- Removed destructive `.snakemake` cleanup from workflow files.
- Fixed Unicode dash in Bowtie2 command.
- Fixed `singleCell` config list parsing.
