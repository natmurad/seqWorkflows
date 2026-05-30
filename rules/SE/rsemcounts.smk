###############################################################################
########################          COUNTS           ############################
###############################################################################

rule calculate_exp:
    input:
        bam = f"{OUT_STEP_MAP}{{sample}}{{lane}}Aligned.toTranscriptome.out.bam",
        ref = f"{RSEMPREPREF}{PREF}.seq"
    threads: THREADS
    log:
        f"{OUT_STEP_COUNTS}logs/rsem/{{sample}}{{lane}}.log"
    params:
        rsemRef = RSEMPREPREF,
        pref = PREF,
        forward_prob = RSEM_FORWARD_PROB_VALUE,
        outPref =  f"{OUT_STEP_COUNTS}{{sample}}{{lane}}",
        outdir = OUT_STEP_COUNTS,
        logdir = f"{OUT_STEP_COUNTS}logs/rsem/"
    container:
        SEQWORKFLOWS_CONTAINER
    message: "\n\n######------ GENERATING COUNT MATRIX WITH RSEM - SAMPLE = {wildcards.sample} ------######\n"
    output:
        align =  f"{OUT_STEP_COUNTS}{{sample}}{{lane}}.genes.results"
    shell:"""
        mkdir -p {params.outdir} {params.logdir}
        rsem-calculate-expression --bam --no-bam-output -p {threads} \
        --forward-prob {params.forward_prob} \
        {input.bam} {params.rsemRef}{params.pref} {params.outPref} > {log} 2>&1
    """
