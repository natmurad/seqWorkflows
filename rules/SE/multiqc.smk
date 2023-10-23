###############################################################################
######################          MERGE REPORTS          ########################
###############################################################################

rule multiqc_report:
    input:
        raw = expand("{out_dir}fastqcRaw/{sample}{lane}_fastqc.html", out_dir = OUT_STEP_QC,
                     sample=SAMPLES, lane=LANE),
        trimmed = expand("{out_dir}fastqcTrim/{sample}{lane}_trimmed_fastqc.html", out_dir = OUT_STEP_QC,
                         sample=SAMPLES, lane=LANE)
    output:
        raw_html   = OUT_STEP_QC + "fastqcRaw/multiqc_report.html", 
        trim_html  = OUT_STEP_QC + "fastqcTrim/multiqc_report.html" 
    params:
        outdirRaw = OUT_STEP_QC + "fastqcRaw/",
        outdirTrim = OUT_STEP_QC + "fastqcTrim/"
    singularity:
        "docker://staphb/multiqc"
    message: "\n\n######------ MERGING QUALITY REPORTS ------######\n"
    # run to raw data
    # run to trimmed data
    shell:"""
        multiqc {params.outdirRaw} --force --outdir {params.outdirRaw} &&
        multiqc {params.outdirTrim} --force --outdir {params.outdirTrim}
    """