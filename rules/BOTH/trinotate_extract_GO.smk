###############################################################################
######################            EXTRACT GO            ########################
###############################################################################

rule extract_go:
    input:
        xls = OUT_STEP_ANNOTATION + "trinotate_annotation_reportv1.xls"
    output:
        go = OUT_STEP_ANNOTATION + "go_annotations.txt"
    params:
        dir = OUT_STEP_ANNOTATION
    message: "\n\n######------ EXTRACTING GO ASSIGNMENTS ------######\n"
    singularity:
        "docker://trinityrnaseq/trinotate"
    shell:"""
        cd {params.dir} &&
        /usr/local/src/Trinotate/util/extract_GO_assignments_from_Trinotate_xls.pl \
            --Trinotate_xls {input.xls} \
            -G --include_ancestral_terms \
            > {output.go}
        """