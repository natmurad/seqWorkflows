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
    message: "\n\n######------ GENERATING COUNTS MATRIX WITH RSEM - SAMPLE = {wildcards.sample} ------######\n"
    output:
        align =  OUT_STEP_COUNTS + "{sample}.genes.results"
    shell:"""
        rsem-calculate-expression  --bam --no-bam-output -p {params.t} \
        --paired-end --forward-prob 0 \
        {input.bam} {params.rsemRef}{params.pref} {params.outPref}
    """

