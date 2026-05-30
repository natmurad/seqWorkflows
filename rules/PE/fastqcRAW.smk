###############################################################################
#################          QUALITY REPORT RAW DATA          ###################
###############################################################################
rule fastqcRAW:
    input:
      raw1 = f"{INPUTDIR}{{sample}}{{lane}}_{{reads}}1{FQ}",
      raw2 = f"{INPUTDIR}{{sample}}{{lane}}_{{reads}}2{FQ}"
    output:
       html_report1 = f"{OUT_STEP_QC}fastqcRaw/{{sample}}{{lane}}_{{reads}}1_fastqc.html",
       zip_report1 = f"{OUT_STEP_QC}fastqcRaw/{{sample}}{{lane}}_{{reads}}1_fastqc.zip",
       html_report2 = f"{OUT_STEP_QC}fastqcRaw/{{sample}}{{lane}}_{{reads}}2_fastqc.html",
       zip_report2 = f"{OUT_STEP_QC}fastqcRaw/{{sample}}{{lane}}_{{reads}}2_fastqc.zip"
    threads: 2
    log:
       f"{OUT_STEP_QC}logs/fastqcRaw/{{sample}}{{lane}}_{{reads}}.log"
    message: "\n\n######------ RUNNING FASTQC ON RAW READS - SAMPLE = {wildcards.sample} ------######\n"
    params:
       out = f"{OUT_STEP_QC}fastqcRaw/",
       logdir = f"{OUT_STEP_QC}logs/fastqcRaw/"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
       mkdir -p {params.out} {params.logdir}
       fastqc {input.raw1} {input.raw2} --threads {threads} --outdir {params.out} > {log} 2>&1
    """
