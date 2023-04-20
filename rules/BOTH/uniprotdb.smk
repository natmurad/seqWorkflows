##############################################################################
######################       CREATE UNIPROT DB        ########################
##############################################################################

rule uniprotdb:
    output:
        db = OUT_STEP_DOWNLOAD + "uniprot_sprot.fasta"
    params:
        uniprotdb = OUT_STEP_DOWNLOAD,
        t = THREADS
    message: "\n\n######------ DOWNLOADING UNIPROT DATABASE ------######\n"
    shell:"""
        cd {params.uniprotdb} &&
        wget https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz &&
        gunzip uniprot_sprot.fasta.gz
        """