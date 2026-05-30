###############################################################################
######################        TRINITY ASSEMBLY         ########################
###############################################################################

rule trinity_assembly:
    input:
        left= expand("{trim_dir}{sample}{lane}_{reads}1_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                     sample = SAMPLES, lane = LANE, reads=READS),
        right= expand("{trim_dir}{sample}{lane}_{reads}2_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                     sample = SAMPLES, lane = LANE, reads=READS)
    output:
        assembly = ASSEMBLYDIR + ASSEMBLY,
        gene_trans_map = ASSEMBLYDIR + ASSEMBLY + ".gene_trans_map"
    params:
        left = lambda wildcards: ",".join(expand("{trim_dir}{sample}{lane}_{reads}1_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                    sample = SAMPLES, lane = LANE, reads=READS)),
        right = lambda wildcards: ",".join(expand("{trim_dir}{sample}{lane}_{reads}2_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                    sample = SAMPLES, lane = LANE, reads=READS)),
        t = THREADS,
        out = OUT_STEP_ASSEMBLY,
        mem = '50G',
        seqType = 'fq'
    message: "\n\n######------ ASSEMBLY WITH TRINITY ------######\n"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        Trinity --seqType {params.seqType}  \
         --left {params.left} \
         --right {params.right} \
         --output {params.out} \
         --CPU {params.t} --max_memory {params.mem}
        """
