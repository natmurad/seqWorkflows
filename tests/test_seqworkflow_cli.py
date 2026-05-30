#!/usr/bin/env python3
import hashlib
import json
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO_DIR = Path(__file__).resolve().parents[1]
SEQWORKFLOW = REPO_DIR / "bin" / "seqworkflow"


class SeqworkflowCliTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="seqworkflow-test-")
        self.work = Path(self.tmp.name)
        self.r1 = self.touch("S1_R1.fastq.gz")
        self.r2 = self.touch("S1_R2.fastq.gz")
        self.se = self.touch("S1.fastq.gz")
        self.ref = self.touch("genome.fa")
        self.gtf = self.touch("annotation.gtf")

    def tearDown(self):
        self.tmp.cleanup()

    def touch(self, name):
        path = self.work / name
        path.write_text("")
        return path

    def run_cli(self, *args):
        cmd = [str(SEQWORKFLOW), *map(str, args), "--snakemake", "/usr/bin/true", "--dry-run"]
        result = subprocess.run(cmd, cwd=REPO_DIR, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        return result

    def run_cli_raw(self, *args):
        cmd = [str(SEQWORKFLOW), *map(str, args), "--snakemake", "/usr/bin/true", "--dry-run"]
        return subprocess.run(cmd, cwd=REPO_DIR, text=True, capture_output=True)

    def assert_config_contains(self, outdir, mode, *patterns):
        config = outdir / "config" / f"{mode}.yaml"
        self.assertTrue(config.exists(), f"Missing config: {config}")
        text = config.read_text()
        normalized_text = text.replace('"', "").replace("''", "")
        for pattern in patterns:
            normalized_pattern = pattern.replace('"', "").replace("''", "")
            self.assertIn(normalized_pattern, normalized_text)

    def test_help_lists_all_modes(self):
        result = subprocess.run([str(SEQWORKFLOW), "--help"], cwd=REPO_DIR, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        for mode in ("preprocessPE", "preprocessSE", "qcPE", "qC_PE", "denovoPE", "denovoSE", "refguidedPE"):
            self.assertIn(mode, result.stdout)
        self.assertIn("Common options", result.stdout)
        self.assertIn("Containers", result.stdout)

    def test_preprocess_pe_config_and_links(self):
        outdir = self.work / "preprocessPE"
        self.run_cli(
            "preprocessPE",
            self.r1,
            self.r2,
            outdir,
            "--ref-genome",
            self.ref,
            "--gtf-file",
            self.gtf,
            "--runtime",
            "apptainer",
            "--container-image",
            "seqworkflows.sif",
        )
        self.assertTrue((outdir / "input" / "S1_R1.fastq.gz").is_symlink())
        self.assertTrue((outdir / "input" / "S1_R2.fastq.gz").is_symlink())
        self.assertTrue((outdir.parent / "ref" / "rsemRef").is_dir())
        self.assert_config_contains(
            outdir,
            "preprocessPE",
            "samples: S1",
            "container: seqworkflows.sif",
            "strandedness: reverse",
            f"ref_genome: {self.ref.resolve()}",
            f"gtf_file: {self.gtf.resolve()}",
            f"rsemprepref: {(outdir.parent / 'ref' / 'rsemRef').resolve()}/",
        )

    def test_preprocess_pe_accepts_explicit_shared_reference_dir(self):
        outdir = self.work / "preprocessPE-explicit-ref"
        reference_dir = self.work / "references" / "grch38"
        self.run_cli(
            "preprocessPE",
            self.r1,
            self.r2,
            outdir,
            "--ref-genome",
            self.ref,
            "--gtf-file",
            self.gtf,
            "--rsem-ref-dir",
            reference_dir,
        )
        self.assertTrue(reference_dir.is_dir())
        self.assert_config_contains(outdir, "preprocessPE", f"rsemprepref: {reference_dir.resolve()}/")

    def test_reference_runs_reuse_default_shared_reference_dir(self):
        reference_dir = (self.work / "ref" / "rsemRef").resolve()
        for name in ("run-a", "run-b"):
            outdir = self.work / name
            self.run_cli("preprocessPE", self.r1, self.r2, outdir, "--ref-genome", self.ref, "--gtf-file", self.gtf)
            self.assert_config_contains(outdir, "preprocessPE", f"rsemprepref: {reference_dir}/")

    def test_reference_manifest_records_input_hashes(self):
        outdir = self.work / "manifest-run"
        self.ref.write_text(">chr1\nACGT\n")
        self.gtf.write_text("chr1\ttest\tgene\t1\t4\t.\t+\t.\tgene_id \"g1\";\n")
        self.run_cli("preprocessPE", self.r1, self.r2, outdir, "--ref-genome", self.ref, "--gtf-file", self.gtf)
        manifest = json.loads((self.work / "ref" / "rsemRef" / ".seqworkflow-reference.json").read_text())
        self.assertEqual(manifest["reference_genome"]["sha256"], hashlib.sha256(self.ref.read_bytes()).hexdigest())
        self.assertEqual(manifest["annotation"]["sha256"], hashlib.sha256(self.gtf.read_bytes()).hexdigest())
        self.assertEqual(manifest["annotation_type"], "--gtf")
        self.assertEqual(manifest["prefix"], "reference")

    def test_reference_manifest_rejects_incompatible_annotation(self):
        reference_dir = self.work / "ref" / "rsemRef"
        self.run_cli("preprocessPE", self.r1, self.r2, self.work / "run-a", "--ref-genome", self.ref, "--gtf-file", self.gtf)
        other_gtf = self.touch("other-annotation.gtf")
        other_gtf.write_text("different annotation\n")
        result = self.run_cli_raw(
            "preprocessPE",
            self.r1,
            self.r2,
            self.work / "run-b",
            "--ref-genome",
            self.ref,
            "--gtf-file",
            other_gtf,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(f"Reference directory mismatch: {reference_dir.resolve()}", result.stderr)
        self.assertIn("annotation", result.stderr)
        self.assertIn("Use a distinct --rsem-ref-dir", result.stderr)

    def test_reference_manifest_accepts_same_content_from_different_paths(self):
        self.ref.write_text(">chr1\nACGT\n")
        self.gtf.write_text("annotation\n")
        self.run_cli("preprocessPE", self.r1, self.r2, self.work / "run-a", "--ref-genome", self.ref, "--gtf-file", self.gtf)
        relocated_ref = self.touch("relocated-genome.fa")
        relocated_gtf = self.touch("relocated-annotation.gtf")
        relocated_ref.write_bytes(self.ref.read_bytes())
        relocated_gtf.write_bytes(self.gtf.read_bytes())
        self.run_cli(
            "preprocessPE",
            self.r1,
            self.r2,
            self.work / "run-b",
            "--ref-genome",
            relocated_ref,
            "--gtf-file",
            relocated_gtf,
        )

    def test_default_container_is_versioned(self):
        outdir = self.work / "versioned-container"
        self.run_cli("qcPE", self.r1, self.r2, outdir)
        self.assert_config_contains(outdir, "qC_PE", "container: docker://ghcr.io/natmurad/seqworkflows:1.0.0")

    def test_qc_pe_config_and_links(self):
        outdir = self.work / "qC_PE"
        self.run_cli("qcPE", self.r1, self.r2, outdir, "--sample", "sample_qc")
        self.assertTrue((outdir / "input" / "sample_qc_R1.fastq.gz").is_symlink())
        self.assertTrue((outdir / "input" / "sample_qc_R2.fastq.gz").is_symlink())
        self.assert_config_contains(outdir, "qC_PE", "samples: sample_qc", "step_qC: qC/")

    def test_preprocess_se_config_and_link(self):
        outdir = self.work / "preprocessSE"
        self.run_cli("preprocessSE", self.se, outdir, "--ref-genome", self.ref, "--gtf-file", self.gtf)
        self.assertTrue((outdir / "input" / "S1.fastq.gz").is_symlink())
        self.assert_config_contains(
            outdir,
            "preprocessSE",
            "samples: S1",
            "reads: ''",
            f"rsemprepref: {(outdir.parent / 'ref' / 'rsemRef').resolve()}/",
        )

    def test_denovo_pe_generates_de_files(self):
        outdir = self.work / "denovoPE"
        self.run_cli("denovoPE", self.r1, self.r2, outdir, "--contrasts", "A_vs_B")
        self.assertTrue((outdir / "input" / "sample_file.txt").exists())
        self.assertTrue((outdir / "input" / "contrast_file.txt").exists())
        self.assert_config_contains(outdir, "denovoPE", "contrasts: A_vs_B", "assembly_name: trinity.Trinity.fasta")

    def test_denovo_se_generates_de_files(self):
        outdir = self.work / "denovoSE"
        self.run_cli("denovoSE", self.se, outdir)
        self.assertTrue((outdir / "input" / "S1.fastq.gz").is_symlink())
        self.assertTrue((outdir / "input" / "sample_file.txt").exists())
        self.assert_config_contains(outdir, "denovoSE", "samples: S1", "reads: ''")

    def test_refguided_pe_config(self):
        outdir = self.work / "refguidedPE"
        self.run_cli("refguidedPE", self.r1, self.r2, outdir, "--ref-genome", self.ref, "--gtf-file", self.gtf)
        self.assert_config_contains(
            outdir,
            "refguidedPE",
            "samples: S1",
            f"ref_genome: {self.ref.resolve()}",
            "step_assembly: assembly_trinity/trinity/",
            f"rsemprepref: {(outdir.parent / 'ref' / 'rsemRef').resolve()}/",
        )


if __name__ == "__main__":
    unittest.main()
