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
        rsemRef = RSEMPREPREF,
        t = THREADS,
        pref = PREF,
        gtf_gff = GTF_GFF,
    singularity:
        "docker://dceoy/rsem"
    shell:"""
        cd {params.rsemRef}
        rsem-prepare-reference {params.gtf_gff} {input.gtfFile} \
        -p {params.t} --star --star-path /usr/local/bin/ \
        {input.refGenome} {params.pref}
    """
