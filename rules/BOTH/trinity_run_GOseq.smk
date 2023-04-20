###############################################################################
########################        RUN GO ANALYSIS    ############################
###############################################################################

rule run_GOseq:
    input:
        rsemMtx = INPUTDIR + "diff_exp/DESeq2_gene/RSEM.gene.counts.matrix.A_vs_B.DESeq2.count_matrix",
        assembly = ASSEMBLYDIR + "trinity.Trinity.fasta",
        gene_trans_map = ASSEMBLYDIR + "trinity.Trinity.fasta.gene_trans_map",
        tmm = OUT_STEP_COUNTS + "RSEM.isoform.TMM.EXPR.matrix",
        sample_file = INPUTDIR + "sample_file.txt",
        go = OUT_STEP_ANNOTATION + "go_annotations.txt",
        factorLabel = INPUTDIR + "diff_exp/DESeq2_gene/factor_labeling.txt"
    params:
        out_dir = INPUTDIR + "diff_exp/",
        go_dir = INPUTDIR + "/diff_exp/DESeq2_gene/",
    message: "\n\n######------ RUNNING GO ANALYSIS ------######\n"
    output:
        seqLens = INPUTDIR + "diff_exp/Trinity.fasta.seq_lens",
        gene_lengths = INPUTDIR + "Trinity.gene_lengths.txt",
        go_res = INPUTDIR + "diff_exp/DESeq2_gene/A_B.GOseq.enriched"
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
            cd {params.out_dir} &&
            $TRINITY_HOME/util/misc/fasta_seq_length.pl  {input.assembly} > {output.seqLens} &&
            $TRINITY_HOME/util/misc/TPM_weighted_gene_length.py  \
                --gene_trans_map {input.gene_trans_map} \
                --trans_lengths {output.seqLens} \
                --TPM_matrix {input.tmm} > {output.gene_lengths} &&
            cd {params.go_dir} &&
            $TRINITY_HOME/Analysis/DifferentialExpression/run_GOseq.pl \
                       --factor_labeling  {input.factorLabel} \
                       --GO_assignments {input.go} \
                       --lengths {output.gene_lengths} \
                       --background {input.rsemMtx}
    """