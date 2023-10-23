###############################################################################
########################          COUNTS           ############################
###############################################################################

rule calculate_exp:
    input:
        bam = OUT_STEP_MAP + "{sample}{lane}Aligned.toTranscriptome.out.bam",
        ref = RSEMPREPREF + PREF + ".seq"
    params:
        t = THREADS,
        rsemRef = RSEMPREPREF,
        pref = PREF,
        outPref =  OUT_STEP_COUNTS + "{sample}{lane}"
    singularity:
        "docker://dceoy/rsem"
    message: "\n\n######------ GENERATING COUNT MATRIX WITH RSEM - SAMPLE = {wildcards.sample} ------######\n"
    output:
        align =  OUT_STEP_COUNTS + "{sample}{lane}.genes.results"
    shell:"""
        rsem-calculate-expression --bam --no-bam-output -p {params.t} \
        {input.bam} {params.rsemRef}{params.pref} {params.outPref}
    """