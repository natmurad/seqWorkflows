###############################################################################
######################          MERGE REPORTS          ########################
###############################################################################

rule multiqc_report:
    input:
        raw = expand("{out_dir}fastqcRaw/{sample}{lane}_{reads}2_fastqc.html", out_dir = OUT_STEP_QC,
                     sample=SAMPLES, lane=LANE, reads=READS),
        trimmed = expand("{out_dir}fastqcTrim/{sample}{lane}_{reads}2_trimmed2_fastqc.html", out_dir = OUT_STEP_QC,
                         sample=SAMPLES, lane=LANE, reads=READS)
    output:
        raw_html   = f"{OUT_STEP_QC}fastqcRaw/multiqc_report.html",
        trim_html  = f"{OUT_STEP_QC}fastqcTrim/multiqc_report.html"
    log:
        f"{OUT_STEP_QC}logs/multiqc.log"
    params:
        outdirRaw = f"{OUT_STEP_QC}fastqcRaw/",
        outdirTrim = f"{OUT_STEP_QC}fastqcTrim/",
        logdir = f"{OUT_STEP_QC}logs/"
    container:
        SEQWORKFLOWS_CONTAINER
    message: "\n\n######------ MERGING QUALITY REPORTS ------######\n"
    # run to raw data
    # run to trimmed data
    shell:"""
        mkdir -p {params.outdirRaw} {params.outdirTrim} {params.logdir}
        multiqc --force {params.outdirRaw} --outdir {params.outdirRaw} > {log} 2>&1
        multiqc --force {params.outdirTrim} -f --outdir {params.outdirTrim} >> {log} 2>&1
    """
