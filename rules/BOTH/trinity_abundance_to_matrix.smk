###############################################################################
########################    ABUNDANCE TO MATRIX    ############################
###############################################################################

rule abundance_to_matrix:
    input:
        counts = expand("{out_dir}{sample}{lane}/RSEM.isoforms.results", out_dir = OUT_STEP_COUNTS,  sample=SAMPLES, lane=LANE),
        gene_trans_map = ASSEMBLYDIR + ASSEMBLY + ".gene_trans_map"
    params:
        seqType = 'fq',
        est_method = 'RSEM',
        out_dir = OUT_STEP_COUNTS
    message: "\n\n######------ ABUNDANCE TO MATRIX ------######\n"
    output:
        mtx =  OUT_STEP_COUNTS + "RSEM.isoform.counts.matrix",
        mtx_gene =  OUT_STEP_COUNTS + "RSEM.gene.counts.matrix",
        tmm = OUT_STEP_COUNTS + "RSEM.isoform.TMM.EXPR.matrix"
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
        cd {params.out_dir} &&
        $TRINITY_HOME/util/abundance_estimates_to_matrix.pl --est_method {params.est_method} \
            --gene_trans_map {input.gene_trans_map} \
            --out_prefix {params.est_method} \
            --name_sample_by_basedir \
            {input.counts}
    """