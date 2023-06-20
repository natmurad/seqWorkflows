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

  #  rsem-prepare-reference --gff3 /home/buckcenter.org/nmurad/antsrnaseq/Hsaltator/GCF_003227715.1_Hsal_v8.5_genomic.gff \
  #  --star --star-path /usr/local/bin/ -p 20 /home/buckcenter.org/nmurad/antsrnaseq/Hsaltator/GCF_003227715.1_Hsal_v8.5_genomic.fa \
  #  hsaltator_ref