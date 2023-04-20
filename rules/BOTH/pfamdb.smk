##############################################################################
######################             PFAM DB            ########################
##############################################################################

rule pfamdb:
    output:
        db = OUT_STEP_DOWNLOAD + "Pfam-A.hmm"
    params:
        pfamdb = OUT_STEP_DOWNLOAD,
        t = THREADS
    message: "\n\n######------ DOWNLOAD PFAM DATABASE ------######\n"    
    shell:"""
        cd {params.pfamdb} &&
        wget https://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz &&
        gunzip Pfam-A.hmm.gz
        """