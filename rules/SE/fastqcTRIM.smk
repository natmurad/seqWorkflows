###############################################################################
###############          QUALITY REPORT TRIMMED DATA          #################
###############################################################################

rule fastqcTRIM:
    input:
#     "/path/to/fastq.gz/trimmed/sample.fastq.gz"
       TRIMMEDDIR + "{sample}{lane}" + "_trimmed.fq.gz"
    output:
        html_report = OUT_STEP_QC + "fastqcTrim/{sample}{lane}" + "_trimmed_fastqc.html",
        zip_report = OUT_STEP_QC + "fastqcTrim/{sample}{lane}"  + "_trimmed_fastqc.zip"
    params:
        out = OUT_STEP_QC + "fastqcTrim/"
    singularity:
      "docker://staphb/fastqc"    
    message: "\n\n######------ RUNNING FASTQC ON TRIMMED READS - SAMPLE = {wildcards.sample} ------######\n"
    shell:"""
        fastqc {input} --outdir {params.out}
    """ 