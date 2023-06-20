###############################################################################
######################         TRINOTATE SQLITE DB     ########################
###############################################################################

rule copy_db:
    input:
        assembly = ASSEMBLYDIR + ASSEMBLY,
        pep = OUT_STEP_TRANSDECODER + "longest_orfs.pep",
        outfmt6 = OUT_STEP_ANNOTATION + "uniprot.blastx.outfmt6",
    output:
       # trinotatesqlite = OUT_STEP_DOWNLOAD + "Trinotate.sqlite",
        trinotatesqlite_cp = OUT_STEP_ANNOTATION + "Trinotate.sqlite",
    message: "\n\n######------ DOWNLOAD TRINOTATE SQLITE DB ------######\n"
    singularity:
        "docker://trinityrnaseq/trinotate"
    shell:"""
        cp data/Trinotate.sqlite {output.trinotatesqlite_cp}
        """