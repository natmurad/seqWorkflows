###############################################################################
######################        UNIPROT BLAST DB         ########################
###############################################################################

rule blastx:
    input:
        pep = ASSEMBLYDIR + "trinity.Trinity.fasta",
        uniprotdb = OUT_STEP_DOWNLOAD + "uniprot_sprot.fasta",
        pdb = OUT_STEP_DOWNLOAD + "uniprot_sprot.fasta.pdb"
    output:
        outfmt = OUT_STEP_ANNOTATION + "uniprot.blastx.outfmt6"
    params:
        t = THREADS
    singularity:
        "docker://ncbi/blast"
    shell:"""
        blastx -db {input.uniprotdb} -query {input.pep} -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads {params.t}  > {output.outfmt}
        """
