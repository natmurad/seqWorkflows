###############################################################################
#######################   CREATE GENE LEN FILES    ############################
###############################################################################

rule run_geneLen:
    input:
        assembly = ASSEMBLYDIR + ASSEMBLY,
        gene_trans_map = ASSEMBLYDIR + ASSEMBLY + ".gene_trans_map",
        tmm = OUT_STEP_COUNTS + "RSEM.isoform.TMM.EXPR.matrix",
        go = OUT_STEP_ANNOTATION + "go_annotations.txt",
    params:
        out_dir = INPUTDIR + "diff_exp/",
    message: "\n\n######------ CREATE GENE LENGTH FILES ------######\n"
    output:
        seqLens = INPUTDIR + "diff_exp/Trinity.fasta.seq_lens",
        gene_lengths = INPUTDIR + "Trinity.gene_lengths.txt"
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
            cd {params.out_dir} &&
            /usr/local/bin/util/misc/fasta_seq_length.pl  {input.assembly} > {output.seqLens} &&
            /usr/local/bin/util/misc/TPM_weighted_gene_length.py  \
                --gene_trans_map {input.gene_trans_map} \
                --trans_lengths {output.seqLens} \
                --TPM_matrix {input.tmm} > {output.gene_lengths} 
    """