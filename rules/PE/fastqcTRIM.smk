###############################################################################
###############          QUALITY REPORT TRIMMED DATA          #################
###############################################################################

rule fastqcTRIM:
    input:
#     "/path/to/fastq.gz/trimmed/sample.fastq.gz"
        trim1 = TRIMMEDDIR + "{sample}{lane}" + "_{reads}1_trimmed.fq.gz",
        trim2 = TRIMMEDDIR + "{sample}{lane}" + "_{reads}2_trimmed.fq.gz"
    output:
        html_report = OUT_STEP_QC + "fastqcTrim/{sample}{lane}" + "_{reads}1_trimmed_fastqc.html",
        html_report2 = OUT_STEP_QC + "fastqcTrim/{sample}{lane}" + "_{reads}2_trimmed_fastqc.html",
    params:
        out = OUT_STEP_QC + "fastqcTrim/"
    singularity:
      "docker://staphb/fastqc"    
    message: "\n\n######------ RUNNING FASTQC ON TRIMMED READS - SAMPLE = {wildcards.sample} ------######\n"
    shell:"""
        fastqc {input.trim1} {input.trim2} --outdir {params.out}
    """ 