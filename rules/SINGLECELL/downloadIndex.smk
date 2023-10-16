###############################################################################
###########################      DOWNLOAD INDEX     ###########################
###############################################################################
rule download_index:
    params:
        index_site = CELLRANGERREF,
        refname = REFNAME + ".tar.gz",
        indexdir = CELLRANGERINDEXDIR
    output:
        indexgz = CELLRANGERINDEXDIR + REFNAME + ".tar.gz",
        indexdir = directory(CELLRANGERINDEXDIR + REFNAME)
    shell:'''
        mkdir -p {params.indexdir} &&
        cd {params.indexdir} &&
        wget {params.index_site} &&
        tar -xvf {params.refname}
    '''
