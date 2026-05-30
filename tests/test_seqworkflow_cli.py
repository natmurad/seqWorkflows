#!/usr/bin/env python3
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

    def assert_config_contains(self, outdir, mode, *patterns):
        config = outdir / "config" / f"{mode}.yaml"
        self.assertTrue(config.exists(), f"Missing config: {config}")
        text = config.read_text()
        for pattern in patterns:
            self.assertIn(pattern, text)

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
        self.assert_config_contains(
            outdir,
            "preprocessPE",
            "samples: S1",
            "container: seqworkflows.sif",
            "strandedness: reverse",
            f"ref_genome: {self.ref.resolve()}",
            f"gtf_file: {self.gtf.resolve()}",
        )

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
        self.assert_config_contains(outdir, "preprocessSE", "samples: S1", "reads: ''")

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
        )


if __name__ == "__main__":
    unittest.main()
