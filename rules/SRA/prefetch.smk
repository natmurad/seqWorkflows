###############################################################################
######################          DOWNLOAD DATA          ########################
###############################################################################

rule prefetch:
    output:
        srafile = INPUTDIR + "{sample}.sra"
    params:
        sramid = INPUTDIR + "{sample}/{sample}.sra",
        folder = INPUTDIR + "{sample}/",
        sra =  "{sample}",
        out_dir = INPUTDIR
    singularity:
        "docker://pegi3s/sratoolkit"
    message: "\n\n######------ DOWNLOADING RAW SEQUENCE DATA FROM SRA ------######\n"
    shell:"""
        prefetch \
        -O {params.out_dir} {params.sra}  --max-size 50g &&
        mv {params.sramid} {output.srafile} &&
        rm -rf {params.folder}
        """