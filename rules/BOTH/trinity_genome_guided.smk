###############################################################################
######################        TRINITY ASSEMBLY         ########################
###############################################################################

rule trinity_guided_assembly:
    input:
        bam = ASSEMBLYDIR + "merged_sorted_bam.bam",
    output:
        assembly = ASSEMBLYDIR + ASSEMBLY,
    params:
        t = THREADS,
        mem = '50G',
        out = ASSEMBLYDIR,
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
        Trinity \
            --genome_guided_bam {input.bam} \
            --genome_guided_max_intron 10000 \
            --max_memory {params.mem} \
            --CPU {params.t} \
            --output {params.out}
        """

