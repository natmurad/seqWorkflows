###############################################################################
########################          COUNTS           ############################
###############################################################################

rule calculate_exp:
    input:
        bam = OUT_STEP_MAP + "{sample}Aligned.toTranscriptome.out.bam"
    params:
        t = THREADS,
        rsemRef = RSEMPREPREF,
        pref = PREF,
        outPref =  OUT_STEP_COUNTS + "{sample}"
    singularity:
        "docker://dceoy/rsem"
    output:
        align =  OUT_STEP_COUNTS + "{sample}.genes.results"
    shell:"""
        rsem-calculate-expression --bam --no-bam-output -p {params.t} \
        {input.bam} {params.rsemRef}{params.pref} {params.outPref}
    """