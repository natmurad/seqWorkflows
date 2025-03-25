###############################################################################
#########################          MAPPING           ##########################
###############################################################################
rule map:
    input:
        read1 = TRIMMEDDIR + "{sample}{lane}" + "_{reads}1_trimmed.fq.gz",
        read2 = TRIMMEDDIR + "{sample}{lane}" + "_{reads}2_trimmed.fq.gz",
        ref = RSEMPREPREF + PREF + ".seq"
    output:
        align = OUT_STEP_MAP + "{sample}{lane}{reads}Aligned.sortedByCoord.out.bam", # sample.aligned.sortedByCoord.out.bam,
        bam = OUT_STEP_MAP + "{sample}{lane}{reads}Aligned.toTranscriptome.out.bam",
    message: "\n\n######------ MAPPING READS WITH STAR - SAMPLE = {wildcards.sample} ------######\n"
    params:
        t = THREADS,
        outPref =  OUT_STEP_MAP + "{sample}{lane}{reads}",
        refdir = STARINDEXDIR
    singularity:
        "docker://dceoy/star"
    shell:"""
        ulimit -n 10000
        rm -rf {params.outPref}
        mkdir -p {params.outPref}
        STAR --genomeDir {params.refdir} \
        --readFilesIn {input.read1} {input.read2} \
        --runThreadN {params.t} --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate \
        --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix {params.outPref} 
  """
