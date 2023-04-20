###############################################################################
######################            SIGNAL P             ########################
###############################################################################

rule signalp:
    input:
        pep = OUT_STEP_TRANSDECODER + "trinity.Trinity.fasta.transdecoder.pep",
    output:
        out = OUT_STEP_ANNOTATION + "signalp/prediction_results.txt"
    params:
        od = OUT_STEP_ANNOTATION + "signalp/",
        org = "euk"
    message: "\n\n######------ PREDICTING SINAL PEPTIDES AND TRANSMEMBRANE DOMAINS WITH SIGNAL P ------######\n"
    singularity:
        "docker://aswaffordlbl/signalp6"
    shell:"""
        signalp6  --fastafile {input.pep} \
        --output_dir {params.od}  --organism {params.org} \
        --format none
        """