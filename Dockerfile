FROM debian:jessie
MAINTAINER SSE4 <tomskside@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    xz-utils \
    python \
    build-essential && \
    curl https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz | tar -xz

COPY build-clang.sh /build-clang.sh
RUN chmod +x /build-clang.sh

ENV PATH=$PATH:/cmake-3.10.2-Linux-x86_64/bin
