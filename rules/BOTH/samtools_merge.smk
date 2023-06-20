###############################################################################
######################        MERGE BAM FILES          ########################
###############################################################################

rule samtools_merge:
    input:
        sortedBam = expand("{map_dir}{sample}Aligned.sortedByCoord.out.bam", map_dir = OUT_STEP_MAP,
                     sample = SAMPLES),
    output:
        mergedBam = ASSEMBLYDIR + "merged_sorted_bam.bam",
    singularity:
        "docker://dceoy/samtools"
    shell:"""
            samtools merge {output.mergedBam} {input.sortedBam}
        """