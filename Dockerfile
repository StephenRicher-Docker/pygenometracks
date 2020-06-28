#################### BASE IMAGE ######################

FROM python:3.8-slim AS install

#################### METADATA ########################

LABEL base.image="python:3.8-slim"
LABEL version="1"
LABEL software="pyGenomeTracks"
LABEL software.version="3.4"
LABEL about.summary="Plot beautiful and highly customizable genome browser tracks."
LABEL about.home="https://github.com/deeptools/pyGenomeTracks"
LABEL about.documentation="https://github.com/deeptools/pyGenomeTracks/blob/master/README.md"
LABEL license="https://github.com/deeptools/pyGenomeTracks/blob/master/LICENSE"
LABEL about.tags="Genomics"

#################### MAINTAINER ######################

MAINTAINER Stephen Richer <sr467@bath.ac.uk>

#################### INSTALL #########################

ENV URL=git+https://github.com/deeptools/pyGenomeTracks.git

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      pkg-config \
      git \
      libcurl4-openssl-dev \
      zlib1g-dev \
      libfreetype6-dev

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install -U pip && \
    pip install $URL

#################### FINALISE ########################

FROM python:3.8-slim

COPY --from=install /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libfreetype6-dev \
      libcurl4-openssl-dev && \
    useradd --create-home --home-dir /home/guest \
      --uid 1000 --gid 100 --shell /bin/bash guest

USER guest

CMD ["pyGenomeTracks"]
