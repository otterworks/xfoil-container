FROM debian:trixie-slim
MAINTAINER https://github.com/otterworks/xfoil-container/issues

ARG TGZ_URL=https://web.mit.edu/drela/Public/web/xfoil/xfoil6.99.tgz

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      gfortran \
      libx11-dev \
      patch \
 && apt-get autoremove --yes && apt-get clean

WORKDIR /tmp
RUN curl -#SL $TGZ_URL | tar -xzv
WORKDIR /tmp/Xfoil

COPY Makefile.patch .
RUN patch -bp1 < Makefile.patch

WORKDIR /tmp/Xfoil/plotlib
RUN make

WORKDIR /tmp/Xfoil/bin
RUN make -f Makefile_gfortran all
RUN make -f Makefile_gfortran install
# ^This last line^ is where you would use `sudo` as a normal user outside a container.

CMD xfoil
