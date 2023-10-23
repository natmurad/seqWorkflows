###############################################################################
######################          BOWTIE MAP             ########################
###############################################################################

rule bowtie2:
    input:
        assembly = ASSEMBLYDIR + "Trinity.fasta",
        reads = TRIMMEDDIR + "{sample}" + LANE + "_trimmed.fq.gz"
    output:
        map = OUT_STEP_MAP + "/{sample}_bowtie2.sam"
    params:
        t = THREADS,
        index = BTINDEX + "trinity",
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
        bowtie2 --quiet -p {params.t} -x {params.index} -q --local --no-unal -U {input.reads} –S {output.map}
    """
