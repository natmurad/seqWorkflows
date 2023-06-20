###############################################################################
#########################          MAPPING           ##########################
###############################################################################

rule map:
    input:
        reads = TRIMMEDDIR + "{sample}" + LANE + "_trimmed.fq.gz",
        ref = RSEMPREPREF + PREF + ".seq"
    output:
        align = OUT_STEP_MAP + "{sample}Aligned.sortedByCoord.out.bam", # sample.aligned.sortedByCoord.out.bam
        talign = OUT_STEP_MAP + "{sample}Aligned.toTranscriptome.out.bam"
    params:
        t = THREADS,
        outPref =  OUT_STEP_MAP + "{sample}",
        refdir = STARINDEXDIR
    singularity:
        "docker://dceoy/star"
    shell:"""
        rm -rf {params.outPref}
        mkdir -p {params.outPref}
        STAR --genomeDir {params.refdir} --readFilesIn {input.reads} --runThreadN {params.t} --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix {params.outPref}
  """