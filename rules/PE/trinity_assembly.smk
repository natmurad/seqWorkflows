###############################################################################
######################        TRINITY ASSEMBLY         ########################
###############################################################################

rule trinity_assembly:
    input:
        left= expand("{trim_dir}{sample}{lane}_1_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                     sample = SAMPLES, lane = LANE),
        right= expand("{trim_dir}{sample}{lane}_2_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                     sample = SAMPLES, lane = LANE)
    output:
        assembly = ASSEMBLYDIR + ASSEMBLY,
        gene_trans_map = ASSEMBLYDIR + ASSEMBLY + ".gene_trans_map"
    params:
        left = lambda wildcards: ",".join(expand("{trim_dir}{sample}{lane}_1_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                    sample = SAMPLES, lane = LANE)),
        right = lambda wildcards: ",".join(expand("{trim_dir}{sample}{lane}_2_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                    sample = SAMPLES, lane = LANE)),
        t = THREADS,
        out = OUT_STEP_ASSEMBLY,
        mem = '50G',
        seqType = 'fq'
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
        Trinity --seqType {params.seqType}  \
         --left {params.left} \
         --right {params.right} \
         --output {params.out} \
         --CPU {params.t} --max_memory {params.mem}
        """