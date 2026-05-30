
###############################################################################
########################     ALIGN & ABUNDANCE     ############################
###############################################################################

rule align_and_estimate_abundance:
    input:
        left = f"{TRIMMEDDIR}{{sample}}{{lane}}_{READS}1_trimmed.fq.gz",
        right = f"{TRIMMEDDIR}{{sample}}{{lane}}_{READS}2_trimmed.fq.gz",
        assembly = ASSEMBLYDIR + ASSEMBLY
    params:
        seqType = 'fq',
        est_method = 'RSEM',
        out_dir = OUT_STEP_COUNTS + "{sample}{lane}"
    message: "\n\n######------ ALIGN & ESTIMATE ABUNDANCE - SAMPLE = {wildcards.sample} ------######\n"
    output:
        counts =  OUT_STEP_COUNTS + "{sample}{lane}/RSEM.genes.results",
        iso =  OUT_STEP_COUNTS + "{sample}{lane}/RSEM.isoforms.results"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        /usr/local/bin/util/align_and_estimate_abundance.pl --transcripts {input.assembly} \
            --seqType {params.seqType} \
            --left {input.left} \
            --right {input.right} \
            --est_method {params.est_method} --aln_method bowtie2 \
            --prep_reference --trinity_mode \
            --output_dir {params.out_dir}
    """
