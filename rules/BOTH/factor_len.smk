###############################################################################
########################    CREATE FACTOR LEN FILE ############################
###############################################################################

rule factor_len:
    input:
        rsemMtx = INPUTDIR + "diff_exp/DESeq2_gene/RSEM.gene.counts.matrix.{contrasts}.DESeq2.DE_results",
    message: "\n\n######------ FACTOR LEN ------######\n"
    output:
        factorLabel = INPUTDIR + "diff_exp/DESeq2_gene/factor_labeling{contrasts}.txt",
    run:
        shell(""" awk -F "\\t" 'NR>1 && $11 < 0.05 {{new_var=$2"_"$3; printf (new_var"\\t"$1"\\n")}}' {input.rsemMtx} > {output.factorLabel} """)