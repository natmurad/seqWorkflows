###############################################################################
######################           RENAME FASTQ          ########################
###############################################################################

rule rename:
    input:
        fastq1 = INPUTDIR + "{sample}" + "_1{fq}",
        fastq2 = INPUTDIR + "{sample}" + "_2{fq}",
    output:
        fastq_named = INPUTDIR + "{sample}" + "_{lane}_1{fq}",
        fastq_named2 = INPUTDIR + "{sample}" + "_{lane}_2{fq}",
    shell:"""
        mv {input.fastq1} {output.fastq_named} &&
        mv {input.fastq2} {output.fastq_named2}       
        """
