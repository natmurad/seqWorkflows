###############################################################################
######################           TRINOTATE REPORT        ########################
###############################################################################

rule trinotate_report:
    input:
        outfmt6p = OUT_STEP_ANNOTATION + "uniprot.blastp.outfmt6",
        outfmt6x = OUT_STEP_ANNOTATION + "uniprot.blastx.outfmt6",
        signalp = OUT_STEP_ANNOTATION + "signalp/prediction_results.txt",
        hmmscan = OUT_STEP_ANNOTATION + "TrinotatePFAM.out",
        trinotatesqlite = OUT_STEP_ANNOTATION + "Trinotate.sqlite"
    output:
        xls = OUT_STEP_ANNOTATION + "trinotate_annotation_reportv2.xls",
    params:
        dir = OUT_STEP_ANNOTATION
    message: "\n\n######------ LOADING FILES GENERATED IN PREVIOUS STEPS AND GENERATING REPORT ------######\n"
    singularity:
        "docker://ss93/trinotate-3.2.1"
    shell:"""
        cd {params.dir} &&
        Trinotate {input.trinotatesqlite} \
            LOAD_swissprot_blastx {input.outfmt6x} &&
        Trinotate {input.trinotatesqlite} \
            LOAD_swissprot_blastp {input.outfmt6p} &&
        Trinotate {input.trinotatesqlite} \
            LOAD_pfam {input.hmmscan} &&
        Trinotate {input.trinotatesqlite} \
            LOAD_signalp {input.signalp} &&
        Trinotate {input.trinotatesqlite} report > {output.xls}
        """
