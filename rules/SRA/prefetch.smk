###############################################################################
######################          DOWNLOAD DATA          ########################
###############################################################################

rule prefetch:
    input:
        sralist =  INPUTDIR + "SraAccList.txt",
    output:
        srafile = INPUTDIR + "{samples}.sra"
    params:
        out_dir = INPUTDIR
    singularity:
        "docker://ncbi/sra-tools"
    message: "\n\n######------ DOWNLOADING RAW SEQUENCE DATA FROM SRA ------######\n"
    shell:"""
        prefetch \
        -O {params.out_dir} --gzip  {input.sralist}
        """