FROM debian:trixie-slim as builder
MAINTAINER https://github.com/otterworks/xfoil-container/issues

ARG TGZ_URL=https://web.mit.edu/drela/Public/web/xfoil/xfoil6.99.tgz

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      gfortran \
      libx11-dev \
      patch

RUN curl -#SL $TGZ_URL | tar --no-same-owner --no-same-permissions -C /tmp -xzv
WORKDIR /tmp/Xfoil

COPY Makefile.patch .
RUN patch -bp1 < Makefile.patch

WORKDIR /tmp/Xfoil/plotlib
RUN make

WORKDIR /tmp/Xfoil/bin
RUN make -f Makefile_gfortran all

FROM debian:trixie-slim as runner

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
      libgfortran5 \
      libx11-6 \
 && apt-get autoremove --yes && apt-get clean

COPY --from=builder \
  /tmp/Xfoil/bin/xfoil \
  /tmp/Xfoil/bin/pplot \
  /tmp/Xfoil/bin/pxplot \
  /usr/local/bin/
WORKDIR /tmp/work

CMD xfoil
