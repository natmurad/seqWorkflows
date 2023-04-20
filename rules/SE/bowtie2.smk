###############################################################################
######################          BOWTIE MAP             ########################
###############################################################################

rule bowtie2:
    input:
        assembly = ASSEMBLYDIR + "Trinity.fasta",
        reads = TRIMMEDDIR + "{sample}" + LANE + "_trimmed.fq.gz"
    output:
        map = OUT_STEP_MAP + "/{sample}_bowtie2.sam"
    params:
        t = THREADS,
        index = BTINDEX + "trinity",
    singularity:
        "docker://trinityrnaseq/trinityrnaseq"
    shell:"""
        bowtie2 --quiet -p {params.t} -x {params.index} -q --local --no-unal -U {input.reads} –S {output.map}
    """

#singularity exec trinityrnaseq_latest.sif bowtie2 -p 50 -x /home/buckcenter.org/nmurad/antsrnaseq/Tnylanderi/btIndex/trinity -q --local --no-unal -U /home/buckcenter.org/nmurad/antsrnaseq/Tnylanderi/trimmed/Tnyladeri_queen_abdomen_SAMN16591863_trimmed.fq.gz |
#singularity exec trinityrnaseq_latest.sif samtools view -Sb -@ 2 |
#singularity exec trinityrnaseq_latest.sif samtools sort -@ 2 -m 1G -n –o /home/buckcenter.org/nmurad/antsrnaseq/Tnylanderi/map/Tnyladeri_queen_abdomen_SAMN16591863_bowtie2.nameSorted.bam
