###############################################################################
#################          QUALITY REPORT RAW DATA          ###################
###############################################################################

rule fastqcRAW:
    input:
       raw = f"{INPUTDIR}{{sample}}{LANE}{FQ}"
    output:
       html_report = f"{OUT_STEP_QC}fastqcRaw/{{sample}}{LANE}_fastqc.html",
       zip_report = f"{OUT_STEP_QC}fastqcRaw/{{sample}}{LANE}_fastqc.zip"
    threads: 2
    log:
       f"{OUT_STEP_QC}logs/fastqcRaw/{{sample}}{LANE}.log"
    params:
       out = f"{OUT_STEP_QC}fastqcRaw/",
       logdir = f"{OUT_STEP_QC}logs/fastqcRaw/"
    container:
        SEQWORKFLOWS_CONTAINER
    message: "\n\n######------ RUNNING FASTQC ON RAW READS - SAMPLE = {wildcards.sample} ------######\n"
    shell:"""
       mkdir -p {params.out} {params.logdir}
       fastqc {input.raw} --threads {threads} --outdir {params.out} > {log} 2>&1
    """
