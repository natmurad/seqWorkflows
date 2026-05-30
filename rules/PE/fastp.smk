###############################################################################
###############         REMOVE POLYG AND POLY X               #################
###############################################################################

rule fastp:
    input:
        trim1 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}1_trimmed.fq.gz",
        trim2 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}2_trimmed.fq.gz"
    output:
        trim1_1 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}1_trimmed2.fq.gz",
        trim2_1 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}2_trimmed2.fq.gz",
        html = f"{OUT_STEP_QC}fastp/{{sample}}{{lane}}_{{reads}}_fastp.html",
        json = f"{OUT_STEP_QC}fastp/{{sample}}{{lane}}_{{reads}}_fastp.json"
    threads: THREADS
    log:
        f"{OUT_STEP_QC}logs/fastp/{{sample}}{{lane}}_{{reads}}.log"
    params:
        out = f"{OUT_STEP_QC}fastp/",
        logdir = f"{OUT_STEP_QC}logs/fastp/"
    container:
        SEQWORKFLOWS_CONTAINER
    message: "\n\n######------ RUNNING FASTP ON TRIMMED READS - SAMPLE = {wildcards.sample} ------######\n"
    shell:"""
        mkdir -p {params.out} {params.logdir}
        fastp \
            -i {input.trim1} \
            -I {input.trim2} \
            -o {output.trim1_1} \
            -O {output.trim2_1} \
            --trim_poly_g \
            --trim_poly_x \
            --length_required 30 \
            --thread {threads} \
            --html {output.html} \
            --json {output.json} > {log} 2>&1
    """
