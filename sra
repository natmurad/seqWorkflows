###############################################################################
##########################          CONFIG          ###########################
###############################################################################

configfile: "/home/seqWorkflows/config/configSC.yaml"

###############################################################################
########################          LIBRARIES          ##########################
###############################################################################

import io
import os
import pandas as pd
import pathlib
from snakemake.exceptions import print_exception, WorkflowError

###############################################################################
######################          SET VARIABLES          ########################
###############################################################################

THREADS = config["threads"]

STEP_CELLRANGERMAP = config["step_cellrangerMap"] # Cellranger indexing and mapping

SAMPLES = config["samples"].split() # sample files
LANE = config["lane"].split() # lane number
READS = config["reads"].split()
FQ = config["fastq"].split()

INPUTDIR = config["raw_data_dir"] # /home/user/
CELLRANGERINDEXDIR = config['crindexdir']

CELLRANGERREF = config["cellranger_refsite"]
REFNAME = config["refname"]

OUT_STEP_CELLRANGERMAP = os.path.join(INPUTDIR, STEP_CELLRANGERMAP) # /home/dataset/map

###############################################################################
#########################          RULE ALL          ##########################
###############################################################################
rule all:
    input:
        srafile = expand("{outdir}{samples}.sra", outdir = INPUTDIR, samples = SAMPLES),
        fastq =  expand("{outdir}{sample}{lane}{reads}{fq}", outdir = INPUTDIR, sample = SAMPLES, lane = LANE, reads = READS, fq = FQ),

###############################################################################
###########################          RULES          ###########################
###############################################################################

###############################################################################
###########################      DOWNLOAD SRA DATA  ###########################
###############################################################################
include:	"rules/SRA/prefetch.smk"

###############################################################################
###########################         FASTQ DUMP      ###########################
###############################################################################
include:	"rules/SE/fastqdump.smk"