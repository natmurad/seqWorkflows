###############################################################################
######################          BOWTIE INDEX           ########################
###############################################################################

rule bowtie2_build:
    input:
        assembly = ASSEMBLYDIR + ASSEMBLY
    output:
        index = directory(BTINDEX),
        index4 =  BTINDEX + "trinity.4.bt2"
    params:
        t = THREADS,
        bt_index = BTINDEX,
        prefix = "trinity"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        cd {params.bt_index} &&
        bowtie2-build {input.assembly} {params.prefix} --threads {params.t}
    """