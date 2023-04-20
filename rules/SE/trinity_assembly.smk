###############################################################################
######################        TRINITY ASSEMBLY         ########################
###############################################################################

rule trinity:
    input:
        reads=  expand("{trim_dir}{sample}{lane}_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                     sample = SAMPLES, lane = LANE),
    output:
        assembly = ASSEMBLYDIR + "trinity.Trinity.fasta",
        genes_map = ASSEMBLYDIR + "trinity.Trinity.fasta.gene_trans_map"
    params:
        reads = lambda wildcards: ",".join(expand("{trim_dir}{sample}{lane}_trimmed.fq.gz", trim_dir = TRIMMEDDIR,
                     sample = SAMPLES, lane = LANE)),
        t = THREADS,
        out = ASSEMBLYDIR + "trinity",
        mem = '50G',
        seqType = 'fq'
    message: "\n\n######------ ASSEMBLING WITH TRINITY ------######\n"
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
        Trinity --seqType {params.seqType} --CPU {params.t} \
            --max_memory {params.mem} \
            --single {params.reads} --output {params.out} --full_cleanup
        """
