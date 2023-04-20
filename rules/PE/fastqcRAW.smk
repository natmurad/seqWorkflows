###############################################################################
#################          QUALITY REPORT RAW DATA          ###################
###############################################################################
rule fastqcRAW:
    input:
#     "/path/to/fastq.gz/sample.fastq.gz"
       raw1 = INPUTDIR + "{sample}{lane}" + "_1" + FQ,
       raw2 = INPUTDIR + "{sample}{lane}" + "_2" + FQ
    output:
       html_report1 = OUT_STEP_QC + "fastqcRaw/{sample}{lane}" + "_1_fastqc.html",
       zip_report1 = OUT_STEP_QC + "fastqcRaw/{sample}{lane}" + "_1_fastqc.zip",
       html_report2 = OUT_STEP_QC + "fastqcRaw/{sample}{lane}" + "_2_fastqc.html",
       zip_report2 = OUT_STEP_QC + "fastqcRaw/{sample}{lane}" + "_2_fastqc.zip"
    message: "\n\n######------ RUNNING FASTQC ON RAW READS - SAMPLE = {wildcards.sample} ------######\n"
    params:
       out = OUT_STEP_QC + "fastqcRaw/"
    singularity:
      "docker://staphb/fastqc"
    shell:"""
       fastqc {input.raw1} {input.raw2} --outdir {params.out}
    """