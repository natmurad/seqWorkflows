###############################################################################
######################           DUMP DATA             ########################
###############################################################################

rule fastqdumpPE:
    input:
        sra =  INPUTDIR + "{samples}.sra",
    output:
        fastq1 = INPUTDIR + "{samples}_1{fq}",
        fastq2 = INPUTDIR + "{samples}_2{fq}",
    params:
        out_dir = INPUTDIR
    singularity:
        "docker://pegi3s/sratoolkit"
    shell:"""
        fastq-dump --split-3 --skip-technical \
        -O {params.out_dir} --gzip  {input.sra}
        """
