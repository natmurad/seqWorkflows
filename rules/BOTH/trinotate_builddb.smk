###############################################################################
######################         TRINOTATE SQLITE DB     ########################
###############################################################################

rule build_db:
    input:
        assembly = ASSEMBLYDIR + ASSEMBLY,
        pep = OUT_STEP_TRANSDECODER + "longest_orfs.pep",
        outfmt6 = OUT_STEP_ANNOTATION + "uniprot.blastx.outfmt6",
    output:
        trinotatesqlite_cp = OUT_STEP_ANNOTATION + "Trinotate.sqlite",
    params:
        db = OUT_STEP_ANNOTATION + "Trinotate",
    message: "\n\n######------ DOWNLOAD TRINOTATE SQLITE DB ------######\n"
    singularity:
        "docker://trinityrnaseq/trinotate"
    shell:"""
        /usr/local/src/Trinotate/util/admin//Build_Trinotate_Boilerplate_SQLite_db.pl {params.db}
        """