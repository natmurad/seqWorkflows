###############################################################################
######################          CREATE INDEX           ########################
###############################################################################

rule index:
    input:
        fa = REF_GENOME, # provide your reference FASTA file
        gtf = GTF_FILE # provide your GTF file
    output:
        directory(STARINDEXDIR) # you can rename the index folder
        # --sjdbOverhang ReadLength-1
    params:
        t = THREADS
    singularity:
        "docker://quay.io/biocontainers/star"
    shell:"""
        STAR --runThreadN {params.t} --runMode genomeGenerate --genomeDir {output} --genomeFastaFiles {input.fa} --sjdbGTFfile {input.gtf} --sjdbOverhang 100
    """