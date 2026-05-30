###############################################################################
######################        UNIPROT BLAST DB         ########################
###############################################################################

rule blastdb:
    input:
        uniprotdb = OUT_STEP_DOWNLOAD + "uniprot_sprot.fasta"
    output:
        pdb = OUT_STEP_DOWNLOAD + "uniprot_sprot.fasta.pdb"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        makeblastdb -in {input.uniprotdb}  -dbtype prot
        """
