###############################################################################
######################          MERGE REPORTS          ########################
###############################################################################

rule multiqc_report:
    input:
        raw = expand("{out_dir}fastqcRaw/{sample}{lane}{reads}_fastqc.zip", out_dir = OUT_STEP_QC,
                     sample=SAMPLES, lane=LANE, reads=READS),
        trimmed = expand("{out_dir}fastqcTrim/{sample}{lane}{reads}_trimmed_fastqc.zip", out_dir = OUT_STEP_QC,
                         sample=SAMPLES, lane=LANE, reads=READS)
    output:
        raw_html   = OUT_STEP_QC + "fastqcRaw/multiqc_report.html", 
  #      raw_stats  = OUT_STEP_QC + "/fastqcRaw/multiqc_data/multiqc_general_stats.txt",
        trim_html  = OUT_STEP_QC + "fastqcTrim/multiqc_report.html" 
   #     trim_stats = OUT_STEP_QC + "/fastqcTrim/multiqc_data/multiqc_general_stats.txt"
    params:
        outdirRaw = OUT_STEP_QC + "fastqcRaw/",
        outdirTrim = OUT_STEP_QC + "fastqcTrim/"
    singularity:
        "docker://staphb/multiqc"
    message: "\n\n######------ MERGING QUALITY REPORTS ------######\n"
    # run to raw data
    # run to trimmed data
    shell:"""
        multiqc {input.raw} --outdir {params.outdirRaw} &&
        multiqc {input.trimmed} --outdir {params.outdirTrim}
    """