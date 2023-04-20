###############################################################################
#########################          MAPPING           ##########################
###############################################################################

rule map:
    input:
        reads = TRIMMEDDIR + "{sample}" + LANE + "_trimmed.fastq.gz",
        refdir = STARINDEXDIR
    output:
        align = OUT_STEP_MAP + "{sample}Aligned.sortedByCoord.out.bam", # sample.aligned.sortedByCoord.out.bam
        talign = OUT_STEP_MAP + "{sample}Aligned.toTranscriptome.out.bam"
    params:
        t = THREADS,
        outPref =  OUT_STEP_MAP + "{sample}"
    singularity:
        "docker://quay.io/biocontainers/star"
    shell:"""
        rm -rf {params.outPref}
        mkdir -p {params.outPref}
        /opt/conda/envs/snakemake/bin/STAR --genomeDir {input.refdir} --readFilesIn {input.reads} --runThreadN {params.t} --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix {params.outPref}
  """