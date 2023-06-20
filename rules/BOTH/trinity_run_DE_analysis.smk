###############################################################################
########################        RUN DE ANALYSIS    ############################
###############################################################################

rule run_DE_analysis:
    input:
        mtx = OUT_STEP_COUNTS + "RSEM.gene.counts.matrix",
        sample_file = INPUTDIR + "sample_file.txt",
        contrasts = INPUTDIR + "contrast_file.txt"
    params:
        method = "DESeq2",
        isopct_cutoff = 10,
        out_dir = INPUTDIR + "diff_exp/"
    message: "\n\n######------ RUNNING DE ANALYSIS ------######\n"
    output:
        de = INPUTDIR + "diff_exp/DESeq2_gene/RSEM.gene.counts.matrix.{contrasts}.DESeq2.DE_results",
        de_mtx = INPUTDIR + "diff_exp/DESeq2_gene/RSEM.gene.counts.matrix.{contrasts}.DESeq2.count_matrix",
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
        cd {params.out_dir} &&
        /usr/local/bin/Analysis/DifferentialExpression/run_DE_analysis.pl \
                --matrix {input.mtx} \
                --samples_file {input.sample_file} \
                --contrasts {input.contrasts} \
                --method {params.method} \
                --output DESeq2_gene
    """
