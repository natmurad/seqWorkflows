###############################################################################
###################          PREPARE REFERENCE           ######################
###############################################################################

rule prepare_ref:
    input:
        gtfFile = GTF_FILE,
        refGenome = REF_GENOME
    output:
        f"{RSEMPREPREF}{PREF}.seq"
    threads: THREADS
    log:
        f"{RSEMPREPREF}logs/rsem_prepare_reference.log"
    params:
        rsemRef = RSEMPREPREF,
        pref = PREF,
        gtf_gff = GTF_GFF,
        logdir = f"{RSEMPREPREF}logs/"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        mkdir -p {params.rsemRef} {params.logdir}
        star_path="$(dirname "$(command -v STAR)")"
        rsem-prepare-reference {params.gtf_gff} {input.gtfFile} \
        -p {threads} --star --star-path "$star_path" \
        {input.refGenome} {params.rsemRef}{params.pref} > {log} 2>&1
    """
