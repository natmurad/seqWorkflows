###############################################################################
#########################          TRIMMING          ##########################
###############################################################################

rule trimSE:
    input:
        raw = f"{INPUTDIR}{{sample}}{{lane}}{FQ}",
    output:
        trimmed = f"{TRIMMEDDIR}{{sample}}{{lane}}_trimmed.fq.gz"
    threads: THREADS
    log:
        f"{OUT_STEP_QC}logs/trimmomatic/{{sample}}{{lane}}.log"
    params:
        adapters = ADAPTERS,
        trimdir = TRIMMEDDIR,
        logdir = f"{OUT_STEP_QC}logs/trimmomatic/"
    message: "\n\n######------ TRIMMING READS FOR SAMPLE = {wildcards.sample} ------######\n"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        mkdir -p {params.trimdir} {params.logdir}
        trimmomatic SE -threads {threads} \
        {input.raw} \
        {output.trimmed} \
        ILLUMINACLIP:{params.adapters}:2:30:10 \
        SLIDINGWINDOW:4:20 LEADING:9 TRAILING:10 MINLEN:50 AVGQUAL:20 > {log} 2>&1
    """
