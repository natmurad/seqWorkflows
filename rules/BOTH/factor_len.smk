###############################################################################
########################    CREATE FACTOR LEN FILE ############################
###############################################################################

rule factor_len:
    input:
        rsemMtx = INPUTDIR + "diff_exp/DESeq2_gene/RSEM.gene.counts.matrix.A_vs_B.DESeq2.DE_results",
#    params:
#        out_dir = INPUTDIR + "diff_exp/",
#        command = """ "\\t" "\$11 < 0.05 {{new_var=\$2"_"\$3; printf (new_var"\\t"\$1"\\n")}}" """
    message: "\n\n######------ FACTOR LEN ------######\n"
    output:
        factorLabel = INPUTDIR + "diff_exp/DESeq2_gene/factor_labeling.txt",
    run:
        shell(""" awk -F "\\t" 'NR>1 && $11 < 0.05 {{new_var=$2"_"$3; printf (new_var"\\t"$1"\\n")}}' {input.rsemMtx} > {output.factorLabel} """)