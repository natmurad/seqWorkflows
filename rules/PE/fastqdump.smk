###############################################################################
######################           DUMP DATA             ########################
###############################################################################

rule prefetch:
    input:
        sralist =  INPUTDIR + "SRAList.txt",
    output:
        fastq = INPUTDIR + "{sample}{reads}" + FQ
    params:
        out_dir = INPUTDIR  
    singularity:
        "docker://ncbi/sra-tools"
    shell:"""
        fastq-dump --split-3 --skip-technical \
        -O {params.out_dir} --gzip  {input.sralist}
        """