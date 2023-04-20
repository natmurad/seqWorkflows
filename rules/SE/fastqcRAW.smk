###############################################################################
#################          QUALITY REPORT RAW DATA          ###################
###############################################################################

rule fastqcRAW:
    input:
#     "/path/to/fastq.gz/sample.fastq.gz"
#       raw = INPUTDIR + "{sample}" + LANE + ".fastq.gz"
       raw = INPUTDIR + "{sample}" + LANE + FQ
    output:
       html_report = OUT_STEP_QC + "fastqcRaw/{sample}" + LANE + "_fastqc.html",
       zip_report = OUT_STEP_QC + "fastqcRaw/{sample}" + LANE + "_fastqc.zip"
    params:
       out = OUT_STEP_QC + "fastqcRaw/"
    singularity:
      "docker://staphb/fastqc"
    message: "\n\n######------ RUNNING FASTQC ON RAW READS - SAMPLE = {wildcards.sample} ------######\n"
    shell:"""
       fastqc {input.raw} --outdir {params.out}
    """