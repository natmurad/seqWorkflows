###############################################################################
######################      MAP READS TO ASSEMBLY      ########################
###############################################################################

bowtie2 -x ecoli -1 SAMPLE_R1.fastq -2 SAMPLE_R2.fastq  --no-unal -p 12 -S SAMPLE.sam

Example for paired-end reads:

% bowtie2 -p 10 -q --no-unal -k 20 -x Trinity.fasta -1 reads_1.fq -2 reads_2.fq  \
     2>align_stats.txt| samtools view -@10 -Sb -o bowtie2.bam 
Example for single-end reads:

% bowtie2 -p 10 -q --no-unal -k 20 -x Trinity.fasta -U single.reads.fq \
     2>align_stats.txt| samtools view -@10 -Sb -o bowtie2.bam 
Visualize statistics:
% cat 2>&1 align_stats.txt


rule bowtie2:
    input:
        sample=["reads/{sample}.1.fastq", "reads/{sample}.2.fastq"],
        idx=multiext(
            "index/genome",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
    output:
        "mapped/{sample}.bam",
    log:
        "logs/bowtie2/{sample}.log",
    params:
        extra="",  # optional parameters
    threads: 8  # Use at least two threads
    wrapper:
        "v1.23.5/bio/bowtie2/align"