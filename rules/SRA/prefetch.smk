###############################################################################
######################          DOWNLOAD DATA          ########################
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
    message: "\n\n######------ DOWNLOADING RAW SEQUENCE DATA FROM SRA ------######\n"
    shell:"""
        prefetch \
        -O {params.out_dir} --gzip  {input.sralist}
        """