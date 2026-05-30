###############################################################################
#########################          TRIMMING          ##########################
###############################################################################
rule trimPE:
    input:
        read1 = f"{INPUTDIR}{{sample}}{{lane}}_{{reads}}1{FQ}",
        read2 = f"{INPUTDIR}{{sample}}{{lane}}_{{reads}}2{FQ}",
    output:
        trimmed1 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}1_trimmed.fq.gz",
        un1 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}1_UN_trimmed.fq.gz",
        trimmed2 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}2_trimmed.fq.gz",
        un2 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}2_UN_trimmed.fq.gz"
    threads: THREADS
    log:
        f"{OUT_STEP_QC}logs/trimmomatic/{{sample}}{{lane}}_{{reads}}.log"
    message: "\n\n######------ TRIMMING READS FOR SAMPLE = {wildcards.sample} ------######\n"
    params:
        adapters = ADAPTERS,
        trimdir = TRIMMEDDIR,
        logdir = f"{OUT_STEP_QC}logs/trimmomatic/"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        mkdir -p {params.trimdir} {params.logdir}
        trimmomatic PE -threads {threads} \
        {input.read1} {input.read2} \
        {output.trimmed1} {output.un1} \
        {output.trimmed2} {output.un2} \
        ILLUMINACLIP:{params.adapters}:2:30:10 \
        SLIDINGWINDOW:4:20 MINLEN:50 AVGQUAL:20 > {log} 2>&1
    """
