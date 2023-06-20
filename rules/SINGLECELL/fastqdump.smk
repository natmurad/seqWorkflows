###############################################################################
######################           DUMP DATA             ########################
###############################################################################

rule fastqdump:
    input:
        sralist =  INPUTDIR + "SraAccList.txt",
    output:
        fastq = INPUTDIR + "{sample}_S1_{lane}{reads}_001{fq}",
    params:
        out_dir = INPUTDIR
    singularity:
        "docker://ncbi/sra-tools"
    shell:"""
        fastq-dump --split-3 --skip-technical \
        -O {params.out_dir} --gzip  {input.sralist}
        """

rule rename:
    input:
        fastq1 = INPUTDIR + "{sample}{reads}{fq}"
    output:
        fastq = INPUTDIR + "{sample}_S1_{lane}{reads}_001{fq}",
    shell:"""
        mv {input.fastq1} {output.fastq}
        """