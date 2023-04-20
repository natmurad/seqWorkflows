###############################################################################
######################           DUMP DATA             ########################
###############################################################################

rule prefetch:
    input:
        sralist =  INPUTDIR + "SRAList.txt",
    output:
        fastq = INPUTDIR + "/{samples}" + FQ
    params:
        out_dir = INPUTDIR
    singularity:
        "docker://ncbi/sra-tools"
    shell:"""
        fastq-dump --split-3 \
        -O {params.out_dir} --gzip  {input.sralist}
        """