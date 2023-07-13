############################      MAP & COUNT     #############################
###############################################################################

def get_run_name(wildcards):
    return "run_{}".format(wildcards.sample)

def get_sample_name(wildcards):
    return format(wildcards.sample)

rule counts:
    input:
        ref = CELLRANGERINDEXDIR + REFNAME,
        fastqs = INPUTDIR + "{sample}_S10{lane}",
    params:
        data_dir = INPUTDIR,
        run = "run_{sample}_S10{lane}",,
        sample = "{sample}",
        out = OUT_STEP_CELLRANGERMAP,
        cor = OUT_STEP_CELLRANGERMAP + "/run_{sample}_S10{lane}"
    output:
        mtx = OUT_STEP_CELLRANGERMAP + "/run_{sample}_S10{lane}/outs/filtered_feature_bc_matrix/matrix.mtx.gz",
        barcode = OUT_STEP_CELLRANGERMAP + "/run_{sample}_S10{lane}/outs/filtered_feature_bc_matrix/features.tsv.gz",
        features = OUT_STEP_CELLRANGERMAP + "/run_{sample}_S10{lane}/outs/filtered_feature_bc_matrix/barcodes.tsv.gz"
     #   log = OUT_STEP_CELLRANGERMAP + "run_{sample}/{sample}_S1_{lane}{reads}_001{fq}.log"
    shell:'''
        cd {params.out} &&
        rm -rf {params.cor} &&
        cellranger count --id={params.run} \
        --fastqs={params.data_dir} \
        --sample={params.sample} \
        --transcriptome={input.ref} &&
        echo "job done" > {output.log}
    '''
