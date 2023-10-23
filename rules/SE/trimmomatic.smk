###############################################################################
#########################          TRIMMING          ##########################
###############################################################################

rule trimSE:
    input:
        raw = INPUTDIR + "{sample}{lane}" + FQ,
    output:
        trimmed = TRIMMEDDIR + "{sample}{lane}" + "_trimmed.fq.gz"
    params:
        t = THREADS,
        adapters = ADAPTERS
    message: "\n\n######------ TRIMMING READS FOR SAMPLE = {wildcards.sample} ------######\n"
    singularity:
        "docker://quay.io/climb-big-data/trimmomatic"
    shell:"""
        trimmomatic SE -threads {params.t} \
        {input.raw} \
        {output.trimmed} \
        ILLUMINACLIP:{params.adapters}:2:30:10 \
        SLIDINGWINDOW:4:20 LEADING:9 TRAILING:10 MINLEN:50 AVGQUAL:20
    """