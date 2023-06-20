###############################################################################
########################        RUN GO ANALYSIS    ############################
###############################################################################

rule run_GOseq:
    input:
        rsemMtx = INPUTDIR + "diff_exp/DESeq2_gene/RSEM.gene.counts.matrix.{contrasts}.DESeq2.count_matrix",
        go = OUT_STEP_ANNOTATION + "go_annotations.txt",
        gene_lengths = INPUTDIR + "Trinity.gene_lengths.txt",
        factorLabel = INPUTDIR + "diff_exp/DESeq2_gene/factor_labeling{contrasts}.txt"
    params:
        out_dir = INPUTDIR + "diff_exp/",
        go_dir = INPUTDIR + "diff_exp/DESeq2_gene/go/{contrasts}",
    message: "\n\n######------ RUNNING GO ANALYSIS ------######\n"
    output:
      #  go_res = INPUTDIR + "diff_exp/DESeq2_gene/go/{go}.GOseq.enriched",
        log = INPUTDIR + "diff_exp/DESeq2_gene/go/{contrasts}/{contrasts}GODONE.txt"
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
            cd {params.go_dir} &&
            /usr/local/bin/Analysis/DifferentialExpression/run_GOseq.pl \
                       --factor_labeling  {input.factorLabel} \
                       --GO_assignments {input.go} \
                       --lengths {input.gene_lengths} \
                       --background {input.rsemMtx} &&
            echo "GO DONE" > {output.log}
    """
     #      cd {params.out_dir} &&
      #      /usr/local/bin/util/misc/fasta_seq_length.pl  {input.assembly} > {output.seqLens} &&
       #     /usr/local/bin/util/misc/TPM_weighted_gene_length.py  \
       #         --gene_trans_map {input.gene_trans_map} \
       #         --trans_lengths {output.seqLens} \
       #         --TPM_matrix {input.tmm} > {output.gene_lengths} &&