###############################################################################
###############          QUALITY REPORT TRIMMED DATA          #################
###############################################################################

rule fastqcTRIM:
    input:
        trim1 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}1_trimmed2.fq.gz",
        trim2 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}2_trimmed2.fq.gz"
    output:
        html_report = f"{OUT_STEP_QC}fastqcTrim/{{sample}}{{lane}}_{{reads}}1_trimmed2_fastqc.html",
        zip_report = f"{OUT_STEP_QC}fastqcTrim/{{sample}}{{lane}}_{{reads}}1_trimmed2_fastqc.zip",
        html_report2 = f"{OUT_STEP_QC}fastqcTrim/{{sample}}{{lane}}_{{reads}}2_trimmed2_fastqc.html",
        zip_report2 = f"{OUT_STEP_QC}fastqcTrim/{{sample}}{{lane}}_{{reads}}2_trimmed2_fastqc.zip",
    threads: 2
    log:
        f"{OUT_STEP_QC}logs/fastqcTrim/{{sample}}{{lane}}_{{reads}}.log"
    params:
        out = f"{OUT_STEP_QC}fastqcTrim/",
        logdir = f"{OUT_STEP_QC}logs/fastqcTrim/"
    container:
        SEQWORKFLOWS_CONTAINER
    message: "\n\n######------ RUNNING FASTQC ON TRIMMED READS - SAMPLE = {wildcards.sample} ------######\n"
    shell:"""
        mkdir -p {params.out} {params.logdir}
        fastqc {input.trim1} {input.trim2} --threads {threads} --outdir {params.out} > {log} 2>&1
    """
