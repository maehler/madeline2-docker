ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION} as build-env
ARG MADELINE_VERSION=2.1.1

RUN apt-get -y --force-yes update
RUN apt-get install -y \
    build-essential \
    cmake \
    gettext \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libz-dev

RUN git clone https://github.com/piratical/Madeline_2.0_PDE.git
WORKDIR Madeline_2.0_PDE
RUN git checkout v.${MADELINE_VERSION}
RUN ./configure --with-include-gettext && make && make install

FROM ubuntu:${UBUNTU_VERSION}
ARG MADELINE_VERSION=2.1.1

RUN apt-get -y --force-yes update
RUN apt-get install -y \
    libcurl4 \
    libxml2
COPY --from=build-env /usr/local/bin/madeline2 /bin/
WORKDIR /

ENTRYPOINT ["madeline2"]

LABEL version="${MADELINE_VERSION}"
