FROM mambaorg/micromamba:1.5.8

COPY --chown=$MAMBA_USER:$MAMBA_USER env/seqworkflows.yml /tmp/seqworkflows.yml
COPY --chown=$MAMBA_USER:$MAMBA_USER env/seqworkflows-linux-64.lock.yml /tmp/seqworkflows-linux-64.lock.yml

RUN micromamba install -y -n base -f /tmp/seqworkflows-linux-64.lock.yml \
    && micromamba clean -a -y

ENV PATH=/opt/conda/bin:$PATH
ENV LC_ALL=C
ENV SEQWORKFLOWS_CONTAINER=docker://seqworkflows:latest

CMD ["/bin/bash"]
