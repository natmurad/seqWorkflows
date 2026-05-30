###############################################################################
###############          QUALITY REPORT TRIMMED DATA          #################
###############################################################################

rule fastqcTRIM:
    input:
       f"{TRIMMEDDIR}{{sample}}{{lane}}_trimmed.fq.gz"
    output:
        html_report = f"{OUT_STEP_QC}fastqcTrim/{{sample}}{{lane}}_trimmed_fastqc.html",
        zip_report = f"{OUT_STEP_QC}fastqcTrim/{{sample}}{{lane}}_trimmed_fastqc.zip"
    threads: 2
    log:
        f"{OUT_STEP_QC}logs/fastqcTrim/{{sample}}{{lane}}.log"
    params:
        out = f"{OUT_STEP_QC}fastqcTrim/",
        logdir = f"{OUT_STEP_QC}logs/fastqcTrim/"
    container:
        SEQWORKFLOWS_CONTAINER
    message: "\n\n######------ RUNNING FASTQC ON TRIMMED READS - SAMPLE = {wildcards.sample} ------######\n"
    shell:"""
        mkdir -p {params.out} {params.logdir}
        fastqc {input} --threads {threads} --outdir {params.out} > {log} 2>&1
    """
