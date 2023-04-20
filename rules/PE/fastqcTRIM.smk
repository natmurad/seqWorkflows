###############################################################################
###############          QUALITY REPORT TRIMMED DATA          #################
###############################################################################
rule fastqcTRIM:
    input:
     #"/path/to/fastq.gz/trimmed/sample.fastq.gz"
       read1 = TRIMMEDDIR + "{sample}{lane}" + "_1_trimmed.fq.gz",
       read2 = TRIMMEDDIR + "{sample}{lane}" + "_2_trimmed.fq.gz"
    output:
        html_report1 = OUT_STEP_QC + "fastqcTrim/{sample}{lane}" + "_1_trimmed_fastqc.html",
        zip_report1 = OUT_STEP_QC + "fastqcTrim/{sample}{lane}" + "_1_trimmed_fastqc.zip",
        html_report2 = OUT_STEP_QC + "fastqcTrim/{sample}{lane}" + "_2_trimmed_fastqc.html",
        zip_report2 = OUT_STEP_QC + "fastqcTrim/{sample}{lane}" + "_2_trimmed_fastqc.zip"
    message: "\n\n######------ RUNNING FASTQC ON TRIMMED READS - SAMPLE = {wildcards.sample} ------######\n"
    params:
        out = OUT_STEP_QC + "fastqcTrim/"
    singularity:
      "docker://staphb/fastqc"
    shell:"""
        fastqc {input.read1} {input.read2} --outdir {params.out}
    """