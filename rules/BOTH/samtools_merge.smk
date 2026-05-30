###############################################################################
######################        MERGE BAM FILES          ########################
###############################################################################

rule samtools_merge:
    input:
        sortedBam = expand(
            "{map_dir}{sample}{lane}{read_token}Aligned.sortedByCoord.out.bam",
            map_dir=OUT_STEP_MAP,
            sample=SAMPLES,
            lane=LANE,
            read_token=f"_{READS}" if READS else "",
        ),
    output:
        mergedBam = ASSEMBLYDIR + "merged_sorted_bam.bam",
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
            mkdir -p {ASSEMBLYDIR}
            samtools merge {output.mergedBam} {input.sortedBam}
        """
