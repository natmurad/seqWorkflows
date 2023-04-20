###############################################################################
######################         TRINOTATE SQLITE DB     ########################
###############################################################################

rule build_db:
    output:
        trinotatesqlite = OUT_STEP_DOWNLOAD + "Trinotate.sqlite",
        trinotatesqlite_cp = OUT_STEP_ANNOTATION + "Trinotate.sqlite"
    params:
        db = OUT_STEP_DOWNLOAD + "Trinotate",
        dir = OUT_STEP_DOWNLOAD
    message: "\n\n######------ DOWNLOAD TRINOTATE SQLITE DB ------######\n"
    singularity:
        "docker://ss93/trinotate-3.2.1"
    shell:"""
        Build_Trinotate_Boilerplate_SQLite_db.pl {params.db} &&
        cp {output.trinotatesqlite} {output.trinotatesqlite_cp}
        """