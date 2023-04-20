###############################################################################
###################          PREPARE REFERENCE           ######################
###############################################################################

rule prepare_ref:
    input:
        gtfFile = GTF_FILE,
        refGenome = REF_GENOME
    output:
        RSEMPREPREF + PREF + ".seq"
    params:
        gtfFile = GTF_FILE,
        rsemRef = RSEMPREPREF,
        t = THREADS,
        pref = PREF
    singularity:
        "docker://quay.io/biocontainers/rsem"
    shell:"""
        cd {params.rsemRef}
        rsem-prepare-reference --gtf {params.gtfFile} \
        -p {params.t} --star --star-path /opt/conda/envs/snakemake/bin/ \
        {input.refGenome} {params.pref}
    """