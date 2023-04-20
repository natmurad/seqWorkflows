###############################################################################
########################     ALIGN & ABUNDANCE     ############################
###############################################################################

rule align_and_estimate_abundance:
    input:
        single = TRIMMEDDIR + "{sample}{lane}" + "_trimmed.fq.gz",
        assembly = ASSEMBLYDIR + "trinity.Trinity.fasta"
    params:
        seqType = 'fq',
        est_method = 'RSEM',
        out_dir = OUT_STEP_COUNTS + "{sample}{lane}"
    message: "\n\n######------ ALIGN & ESTIMATE ABUNDANCE - SAMPLE = {wildcards.sample} ------######\n"
    output:
        counts =  OUT_STEP_COUNTS + "{sample}{lane}/RSEM.genes.results",
        iso =  OUT_STEP_COUNTS + "{sample}{lane}/RSEM.isoforms.results"
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
        /usr/local/bin/util/align_and_estimate_abundance.pl --transcripts {input.assembly} \
            --seqType {params.seqType} \
            --single {input.single} \
            --est_method {params.est_method} --aln_method bowtie2 \
            --prep_reference --trinity_mode \
            --output_dir {params.out_dir}
    """

#/usr/local/bin/util/align_and_estimate_abundance.pl --transcripts /home/buckcenter.org/nmurad/antsrnaseq/Tnylanderi/assembly_trinity/Trinity.fasta \
#            --seqType fq \
#            --single /home/buckcenter.org/nmurad/antsrnaseq/Tnylanderi/trimmed/Tnyladeri_queen_abdomen_SAMN16591861_trimmed.fq.gz \
#            --est_method RSEM --aln_method bowtie2 \
#            --prep_reference --trinity_mode \
#            --output_dir ~/antsrnaseq/Tnylanderi/counts