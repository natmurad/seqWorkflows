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
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        TransDecoder.LongOrfs -t {input.assembly} -O {params.out}
        """