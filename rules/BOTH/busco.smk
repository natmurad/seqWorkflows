###############################################################################
#########################           BUSCO            ##########################
###############################################################################

rule BUSCO:
    input:
        assembly = ASSEMBLYDIR + ASSEMBLY,
    output:
        busco = OUT_STEP_ANNOTATION + "busco/out/short_summary.specific.hymenoptera_odb10.out.txt"
    params:
        t = THREADS,
        out = OUT_STEP_ANNOTATION + "/busco"
    message: "\n\n######------ BUSCO - Benchmarking sets of Universal Single-Copy Orthologs ------######\n"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        cd {params.out} &&
        busco \
        -i {input.assembly} -f \
        -o out -l hymenoptera_odb10 \
        -m transcriptome --cpu {params.t}
    """
