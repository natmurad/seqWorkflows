###############################################################################
########################     FILTER FASTA BY RSEM  ############################
###############################################################################

rule filter_fasta_by_rsem_values:
    input:
        rsem_out = expand("{out_dir}{sample}{lane}/RSEM.isoforms.results", out_dir = OUT_STEP_COUNTS,  sample=SAMPLES, lane=LANE),
        assembly = OUT_STEP_ASSEMBLY + ASSEMBLY
    params:
        tpm_cutoff = 1,
        isopct_cutoff = 10,
    message: "\n\n######------ FILTERING ASSEMBLY BY RSEM EXPRESSION ------######\n"
    output:
        assemblyfilt = ASSEMBLYDIR + "Trinity.filt.fasta",
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
         /usr/local/bin/util/filter_fasta_by_rsem_values.pl --rsem_output {input.rsem_out} \
            --fasta {input.assembly} \
            --output {output.assemblyfilt} \
            --isopct_cutoff {params.isopct_cutoff} --tpm_cutoff {params.tpm_cutoff}
    """
