###############################################################################
######################              HMMSCAN            ########################
###############################################################################

rule HMMSCAN:
    input:
        pep =  OUT_STEP_TRANSDECODER + ASSEMBLY + ".transdecoder.pep",
        db = OUT_STEP_DOWNLOAD + "Pfam-A.hmm"
    output:
        out = OUT_STEP_ANNOTATION + "TrinotatePFAM.out" 
    params:
        t = THREADS,
        c = '0.97',
        mem = 5000
    message: "\n\n######------ HMMER SEARCH AGAINST THE PFAM DATABASE ------######\n"
    container:
        SEQWORKFLOWS_CONTAINER
    shell:"""
        hmmpress -f {input.db} &&
        hmmscan --cpu {params.t} --domtblout {output.out} \
              {input.db} \
              {input.pep}
        """
