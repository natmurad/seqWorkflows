###############################################################################
#########################          MAPPING           ##########################
###############################################################################
rule map:
    input:
        read1 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}1_trimmed.fq.gz",
        read2 = f"{TRIMMEDDIR}{{sample}}{{lane}}_{{reads}}2_trimmed.fq.gz",
        ref = f"{RSEMPREPREF}{PREF}.seq"
    output:
        align = f"{OUT_STEP_MAP}{{sample}}{{lane}}_{{reads}}Aligned.sortedByCoord.out.bam",
        bam = f"{OUT_STEP_MAP}{{sample}}{{lane}}_{{reads}}Aligned.toTranscriptome.out.bam",
    threads: THREADS
    log:
        f"{OUT_STEP_MAP}logs/star/{{sample}}{{lane}}_{{reads}}.log"
    message: "\n\n######------ MAPPING READS WITH STAR - SAMPLE = {wildcards.sample} ------######\n"
    params:
        outPref =  f"{OUT_STEP_MAP}{{sample}}{{lane}}_{{reads}}",
        refdir = STARINDEXDIR,
        outdir = OUT_STEP_MAP,
        logdir = f"{OUT_STEP_MAP}logs/star/"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        ulimit -n 10000
        mkdir -p {params.outdir} {params.logdir}
        STAR --genomeDir {params.refdir} \
        --readFilesIn {input.read1} {input.read2} \
        --runThreadN {threads} --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate \
        --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix {params.outPref} > {log} 2>&1
  """
