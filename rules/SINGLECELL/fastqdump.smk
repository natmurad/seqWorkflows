###############################################################################
######################           DUMP DATA             ########################
###############################################################################

rule fastqdump:
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

#rule rename:
 #   input:
#        fastq1 = INPUTDIR + "{samples}{reads}{fq}"
#   output:
#        fastq_named = INPUTDIR + "{samples}_S1_{lane}{reads}_001{fq}",
#    shell:"""
#        mv {input.fastq1} {output.fastq}
#        """