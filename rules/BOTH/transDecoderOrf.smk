###############################################################################
######################        IDENTIFY LONG ORFS       ########################
###############################################################################

rule transcoder_orf:
    input:
        assembly =  ASSEMBLYDIR + ASSEMBLY
    output:
        pep = OUT_STEP_TRANSDECODER + "longest_orfs.pep",
        cds = OUT_STEP_TRANSDECODER + "longest_orfs.cds",
        gff3 = OUT_STEP_TRANSDECODER + "longest_orfs.gff3"
    params:
        out = INPUTDIR + "transdecoder"
    singularity:
        "docker://quay.io/biocontainers/transdecoder:5.7.0--pl5321hdfd78af_0"
    shell:"""
        TransDecoder.LongOrfs -t {input.assembly} -O {params.out}
        """

