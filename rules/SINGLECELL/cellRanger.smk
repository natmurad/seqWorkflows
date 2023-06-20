############################      MAP & COUNT     #############################
###############################################################################

def get_run_name(wildcards):
    return "run_{}".format(wildcards.sample)

def get_sample_name(wildcards):
    return format(wildcards.sample)

rule counts:
    input:
        ref = CELLRANGERINDEXDIR + REFNAME,
        fastqs = INPUTDIR + "{sample}_S1_{lane}{reads}_001{fq}",
    params:
        data_dir = INPUTDIR,
        run = get_run_name,
        sample = get_sample_name,
        out = OUT_STEP_CELLRANGERMAP,
    output:
        mtx = OUT_STEP_CELLRANGERMAP + "run_{sample}/outs/filtered_feature_bc_matrix/matrix.mtx.gz",
        barcode = OUT_STEP_CELLRANGERMAP + "run_{sample}/outs/filtered_feature_bc_matrix/features.tsv.gz",
        features = OUT_STEP_CELLRANGERMAP + "run_{sample}/outs/filtered_feature_bc_matrix/barcodes.tsv.gz",
        log = OUT_STEP_CELLRANGERMAP + "run_{sample}/{sample}_S1_{lane}{reads}_001{fq}.log"
    shell:'''
        cd {params.out} &&
        cellranger count --id={params.run} \
        --fastqs={params.data_dir} \
        --sample={params.sample} \
        --transcriptome={input.ref} &&
        echo "job done" > {output.log}
    '''