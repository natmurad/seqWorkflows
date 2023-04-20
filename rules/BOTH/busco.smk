###############################################################################
#########################           BUSCO            ##########################
###############################################################################

rule BUSCO:
    input:
        assembly = ASSEMBLYDIR + "trinity.Trinity.fasta",
    output:
        busco = OUT_STEP_ANNOTATION + "busco/out/short_summary.specific.hymenoptera_odb10.out.txt"
    params:
        t = THREADS,
        out = OUT_STEP_ANNOTATION + "/busco"
    message: "\n\n######------ BUSCO - Benchmarking sets of Universal Single-Copy Orthologs ------######\n"
    singularity:
        "docker://ezlabgva/busco:v5.4.4_cv1"
    shell:"""
        cd {params.out} &&
        busco \
        -i {input.assembly} -f \
        -o out -l hymenoptera_odb10 \
        -m transcriptome --cpu {params.t}
    """
