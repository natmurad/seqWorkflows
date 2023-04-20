###############################################################################
########################          COUNTS           ############################
###############################################################################
rule calculate_exp:
    input:
        bam = OUT_STEP_MAP + "/{sample}Aligned.toTranscriptome.out.bam"
    params:
        t = THREADS,
        rsemRef = RSEMPREPREF,
        pref = PREF,
        outPref =  OUT_STEP_COUNTS + "/{sample}"
    singularity:
        "docker://quay.io/biocontainers/rsem"
    message: "\n\n######------ GENERATING COUNTS MATRIX WITH RSEM - SAMPLE = {wildcards.sample} ------######\n"
    output:
        align =  OUT_STEP_COUNTS + "/{sample}.genes.results"
    shell:"""
        rsem-calculate-expression  --paired-end -p {params.t} --alignments --estimate-rspd --no-bam-output {input.bam} {params.rsemRef}{params.pref} {params.outPref}
    """