###############################################################################
######################           DUMP DATA             ########################
###############################################################################

rule fastqdump:
    input:
        sra =  INPUTDIR + "{samples}.sra",
    output:
        fastq = INPUTDIR + "{samples}" + FQ
    params:
        out_dir = INPUTDIR

    container:

        SEQWORKFLOWS_CONTAINER
    message: "\n\n######------ FASTQ-DUMP - SAMPLE = {wildcards.sample} ------######\n"
    shell:"""
        fastq-dump  \
        -O {params.out_dir} --gzip  {input.sra}
        """