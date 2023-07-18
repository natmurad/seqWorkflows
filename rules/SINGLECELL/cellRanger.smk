############################      MAP & COUNT     #############################
###############################################################################

#def get_run_name(wildcards):
#    return "run_{}".format(wildcards.sample)

#def get_sample_name(wildcards):
#    return format(wildcards.sample)

rule counts:
    input:
        ref = CELLRANGERINDEXDIR + REFNAME,
        fastq1 = INPUTDIR + "{sample}_S1_L001_R1_001.fastq.gz",
        fastq2 = INPUTDIR + "{sample}_S1_L001_R2_001.fastq.gz",
    params:
        data_dir = INPUTDIR,
        run = "{sample}",
        sample = "{sample}",
        out = OUT_STEP_CELLRANGERMAP,
    output:
        mtx = OUT_STEP_CELLRANGERMAP + "{sample}/outs/filtered_feature_bc_matrix/matrix.mtx.gz",
        barcode = OUT_STEP_CELLRANGERMAP + "{sample}/outs/filtered_feature_bc_matrix/features.tsv.gz",
        features = OUT_STEP_CELLRANGERMAP + "{sample}/outs/filtered_feature_bc_matrix/barcodes.tsv.gz",
 #       log = OUT_STEP_CELLRANGERMAP + "{sample}/{sample}_S1_{lane}{reads}_001{fq}.log"
    singularity:
        "docker://litd/docker-cellranger"
    shell:'''
        cd {params.out} &&
        cellranger count --id={params.run} \
        --fastqs={params.data_dir} \
        --sample={params.sample} \
        --transcriptome={input.ref}
    '''
