###############################################################################
#########################          TRIMMING          ##########################
###############################################################################
rule trimPE:
    input:
        read1 = INPUTDIR + "{sample}{lane}" + "_1" + FQ,
        read2 = INPUTDIR + "{sample}{lane}" + "_2" + FQ,
    output:
        trimmed1 = TRIMMEDDIR + "{sample}{lane}" + "_1_trimmed.fq.gz",
        un1 = TRIMMEDDIR + "{sample}{lane}" + "_1_UN_trimmed.fq.gz",
        trimmed2 = TRIMMEDDIR + "{sample}{lane}" + "_2_trimmed.fq.gz",
        un2 = TRIMMEDDIR + "{sample}{lane}" + "_2_UN_trimmed.fq.gz"
    message: "\n\n######------ TRIMMING READS FOR SAMPLE = {wildcards.sample} ------######\n"
    params:
        t = THREADS,
        adapters = ADAPTERS
    singularity:
        "docker://quay.io/climb-big-data/trimmomatic"
    shell:"""
        trimmomatic PE -threads {params.t} \
        {input.read1} {input.read2} \
        {output.trimmed1} {output.un1} \
        {output.trimmed2} {output.un2} \
        ILLUMINACLIP:{params.adapters}:2:30:10 \
        SLIDINGWINDOW:4:20 MINLEN:50 AVGQUAL:20
    """
