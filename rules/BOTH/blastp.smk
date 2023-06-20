###############################################################################
######################        UNIPROT BLAST BB         ########################
###############################################################################

rule blastp:
    input:
        pep = OUT_STEP_TRANSDECODER + "trinity.Trinity.fasta.transdecoder.pep",
        uniprotdb = OUT_STEP_DOWNLOAD + "uniprot_sprot.fasta",
        pdb = OUT_STEP_DOWNLOAD + "uniprot_sprot.fasta.pdb"
    output:
        outfmt = OUT_STEP_ANNOTATION + "uniprot.blastp.outfmt6"
    params:
        t = THREADS
    singularity:
        "docker://ncbi/blast"
    shell:"""
        blastp -query {input.pep} -db  {input.uniprotdb} -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads {params.t}  > {output.outfmt}
        """