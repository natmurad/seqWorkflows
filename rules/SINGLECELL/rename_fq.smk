###############################################################################
######################           RENAME FASTQ          ########################
###############################################################################

rule rename:
    input:
        fastq1 = INPUTDIR + "{samples}_1{fq}",
        fastq2 = INPUTDIR + "{samples}_2{fq}",
    output:
        fastq_named = INPUTDIR + "{samples}_S1_L001_R1_001{fq}",
        fastq_named2 = INPUTDIR + "{samples}_S1_L001_R2_001{fq}",
    shell:"""
        mv {input.fastq1} {output.fastq_named} &&
        mv {input.fastq2} {output.fastq_named2}       
        """