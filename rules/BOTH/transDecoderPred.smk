###############################################################################
######################        GENE PREDICTION          ########################
###############################################################################

rule transcoder_pred:
    input:
        assembly =  ASSEMBLYDIR + ASSEMBLY,
        longest_orfs = OUT_STEP_TRANSDECODER + "longest_orfs.cds"
    output:
        pep = OUT_STEP_TRANSDECODER + ASSEMBLY + ".transdecoder.pep",
        gff3 = OUT_STEP_TRANSDECODER + ASSEMBLY + ".transdecoder.gff3",
        cds = OUT_STEP_TRANSDECODER + ASSEMBLY + ".transdecoder.cds",
        bed = OUT_STEP_TRANSDECODER + ASSEMBLY + ".transdecoder.bed"
    singularity:
        "docker://quay.io/biocontainers/transdecoder:5.7.0--pl5321hdfd78af_0"
    params:
        out = INPUTDIR + "transdecoder",
        t = THREADS
    shell:"""
        cd {params.out} &&
        TransDecoder.Predict -t {input.assembly} --cpu {params.t} --single_best_only -O {params.out}
        """
