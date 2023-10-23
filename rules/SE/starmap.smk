###############################################################################
#########################          MAPPING           ##########################
###############################################################################

rule map:
    input:
        reads = TRIMMEDDIR + "{sample}{lane}" + "_trimmed.fq.gz",
        ref = RSEMPREPREF + PREF + ".seq"
    output:
        align = OUT_STEP_MAP + "{sample}{lane}Aligned.sortedByCoord.out.bam", # sample.aligned.sortedByCoord.out.bam
        talign = OUT_STEP_MAP + "{sample}{lane}Aligned.toTranscriptome.out.bam"
    params:
        t = THREADS,
        outPref =  OUT_STEP_MAP + "{sample}{lane}",
        refdir = STARINDEXDIR
    message: "\n\n######------ MAPPING READS TO THE REFERENCE WITH STAR - SAMPLE = {wildcards.sample} ------######\n"
    singularity:
        "docker://dceoy/star"
    shell:"""
        ulimit -n 10000
        rm -rf {params.outPref}
        mkdir -p {params.outPref}
        STAR --genomeDir {params.refdir} --readFilesIn {input.reads} --runThreadN {params.t} --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix {params.outPref}
  """