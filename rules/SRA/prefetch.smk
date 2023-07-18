###############################################################################
######################          DOWNLOAD DATA          ########################
###############################################################################

rule prefetch:
    output:
        srafile = INPUTDIR + "{samples}.sra"
    params:
        sramid = INPUTDIR + "{samples}/{samples}.sra",
        folder = INPUTDIR + "{samples}/",
        sra =  "{samples}",
        out_dir = INPUTDIR
    singularity:
        "docker://pegi3s/sratoolkit"
    message: "\n\n######------ DOWNLOADING RAW SEQUENCE DATA FROM SRA ------######\n"
    shell:"""
        prefetch \
        -O {params.out_dir} {params.sra} &&
        mv {params.sramid} {output.srafile} &&
        rm -rf 
        """