###############################################################################
######################        REMOVE REDUNDANCE        ########################
###############################################################################

rule cdhit:
    input:
        trinity =  ASSEMBLYDIR + ASSEMBLY,
    output:
        assemblyfilt = OUT_STEP_CDHIT + "NRCDS_Trinity.fasta.cdhit" 
    params:
        t = THREADS,
        c = '0.97',
        mem = 5000
    message: "\n\n######------ REMOVING REDUNDANCE WITH CDHIT ------######\n"
    singularity:
        "docker://chrishah/cdhit:v4.8.1"
    shell:"""
        cd-hit-est -i {input.trinity} \
        -o {output.assemblyfilt} -c {params.c} -T {params.t} \
        -M {params.mem}
        """
