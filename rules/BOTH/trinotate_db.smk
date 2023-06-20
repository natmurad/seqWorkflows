###############################################################################
######################            TRINOTATE            ########################
###############################################################################

rule trinotate:
    input:
        assembly = ASSEMBLYDIR + ASSEMBLY,
        genes_map = ASSEMBLYDIR + ASSEMBLY + ".gene_trans_map",
        pep = OUT_STEP_TRANSDECODER + "longest_orfs.pep",
        outfmt6 = OUT_STEP_ANNOTATION + "uniprot.blastp.outfmt6",
        trinotatesqlite = OUT_STEP_ANNOTATION + "Trinotate.sqlite"
    output:
        xls = OUT_STEP_ANNOTATION + "trinotate_annotation_reportv1.xls"
    params:
        dir = OUT_STEP_ANNOTATION
    message: "\n\n######------ ANNOTATION WITH TRINOTATE ------######\n"
    singularity:
        "docker://ss93/trinotate-3.2.1"
    shell:"""
        cd {params.dir} &&
        Trinotate {input.trinotatesqlite} init \
            --gene_trans_map {input.genes_map} \
            --transcript_fasta {input.assembly} \
            --transdecoder_pep {input.pep} --outfmt6 {input.outfmt6} &&
        Trinotate Trinotate.sqlite report > {output.xls}
        """
