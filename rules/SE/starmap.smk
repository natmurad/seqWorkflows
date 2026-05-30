###############################################################################
#########################          MAPPING           ##########################
###############################################################################

rule map:
    input:
        reads = f"{TRIMMEDDIR}{{sample}}{{lane}}_trimmed.fq.gz",
        ref = f"{RSEMPREPREF}{PREF}.seq"
    output:
        align = f"{OUT_STEP_MAP}{{sample}}{{lane}}Aligned.sortedByCoord.out.bam",
        talign = f"{OUT_STEP_MAP}{{sample}}{{lane}}Aligned.toTranscriptome.out.bam"
    threads: THREADS
    log:
        f"{OUT_STEP_MAP}logs/star/{{sample}}{{lane}}.log"
    params:
        outPref =  f"{OUT_STEP_MAP}{{sample}}{{lane}}",
        refdir = STARINDEXDIR,
        outdir = OUT_STEP_MAP,
        logdir = f"{OUT_STEP_MAP}logs/star/"
    message: "\n\n######------ MAPPING READS TO THE REFERENCE WITH STAR - SAMPLE = {wildcards.sample} ------######\n"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        ulimit -n 10000
        mkdir -p {params.outdir} {params.logdir}
        STAR --genomeDir {params.refdir} --readFilesIn {input.reads} --runThreadN {threads} --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix {params.outPref} > {log} 2>&1
  """
