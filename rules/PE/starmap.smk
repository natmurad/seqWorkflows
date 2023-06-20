###############################################################################
#########################          MAPPING           ##########################
###############################################################################
rule map:
    input:
        read1 = TRIMMEDDIR + "{sample}{lane}" + "_1_trimmed.fq.gz",
        read2 = TRIMMEDDIR + "{sample}{lane}" + "_2_trimmed.fq.gz",
        refdir = STARINDEXDIR
    output:
        align = OUT_STEP_MAP + "/{sample}{lane}Aligned.sortedByCoord.out.bam", # sample.aligned.sortedByCoord.out.bam
        talign = OUT_STEP_MAP + "/{sample}{lane}Aligned.toTranscriptome.out.bam"
    message: "\n\n######------ MAPPING READS WITH STAR - SAMPLE = {wildcards.sample} ------######\n"
    params:
        t = THREADS,
        outPref =  OUT_STEP_MAP + "/{sample}{lane}"
    singularity:
        "docker://quay.io/biocontainers/star"
    shell:"""
        rm -rf {params.outPref}
        mkdir -p {params.outPref}
        STAR --genomeDir {input.refdir} \
        --readFilesIn {input.read1} {input.read2} \
        --runThreadN {params.t} --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate \
        --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix {params.outPref} 
  """
  #    --outFilterScoreMinOverLread 0.3 --outFilterMatchNminOverLread 0.3

  #STAR --runThreadN 3 --genomeDir $index \
  #  --readFilesIn $fq1 $fq2 --outSAMtype BAM   SortedByCoordinate \
  #  --outTmpDir /scratch/oknjav001/sarsCovRNA/tempalign --quantMode GeneCounts
  #  --readFilesCommand zcat --outFileNamePrefix $base"_"