###############################################################################
######################           DUMP DATA             ########################
###############################################################################

rule fastqdump:
    input:
        sra =  INPUTDIR + "{sample}.sra",
    output:
        r1 = INPUTDIR + "{sample}_1.fastq.gz",
        r2 = INPUTDIR + "{sample}_2.fastq.gz",
    params:
        out_dir = INPUTDIR  
    wildcard_constraints:
        sample="^[a-zA-Z][a-zA-Z0-9]*$"
    message: "\n\n######------ FASTQ-DUMP - SAMPLE = {wildcards.sample} ------######\n"
    singularity:
        "docker://pegi3s/sratoolkit"
    shell:"""
        fastq-dump --split-3 --skip-technical \
        -O {params.out_dir} --gzip  {input.sra}
        """
