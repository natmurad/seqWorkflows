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
        fastq-dump  \
        -O {params.out_dir} --gzip  {input.sralist}
        """