###############################################################################
######################        IDENTIFY LONG ORFS       ########################
###############################################################################

rule transcoder_orf:
    input:
        assembly =  ASSEMBLYDIR + "trinity.Trinity.fasta"
    output:
        pep = OUT_STEP_TRANSDECODER + "longest_orfs.pep",
        cds = OUT_STEP_TRANSDECODER + "longest_orfs.cds",
        gff3 = OUT_STEP_TRANSDECODER + "longest_orfs.gff3"
    params:
        out = INPUTDIR + "transdecoder"
    singularity:
        "docker://quay.io/biocontainers/transdecoder:5.7.0--pl5321hdfd78af_0"
    shell:"""
        TransDecoder.LongOrfs -t {input.assembly} -O {params.out}
        """






## identify long orfs
#$TRANSDECODER_HOME/TransDecoder.LongOrfs -t ../trinity_out_dir/Trinity.fasta

# Now, run the step that predicts which ORFs are likely to be coding.
#$TRANSDECODER_HOME/TransDecoder.Predict -t ../trinity_out_dir/Trinity.fasta 

#output less Trinity.fasta.transdecoder.pep -> contains the protein sequences corresponding to the predicted coding regions within the transcripts.

