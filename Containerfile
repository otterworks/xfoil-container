FROM alpine as builder
MAINTAINER https://github.com/otterworks/xfoil-container/issues

ARG TGZ_URL=https://web.mit.edu/drela/Public/web/xfoil/xfoil6.99.tgz

RUN apk add --no-cache alpine-sdk curl gfortran libx11-dev

RUN curl -#SL $TGZ_URL | tar --no-same-owner --no-same-permissions -C /tmp -xzv
WORKDIR /tmp/Xfoil

COPY Makefile.patch .
RUN patch -bp1 < Makefile.patch

WORKDIR /tmp/Xfoil/plotlib
RUN make

WORKDIR /tmp/Xfoil/bin
RUN make -f Makefile_gfortran all

FROM alpine as runner

RUN apk add --no-cache libgfortran libx11

COPY --from=builder \
  /tmp/Xfoil/bin/xfoil \
  /tmp/Xfoil/bin/pplot \
  /tmp/Xfoil/bin/pxplot \
  /usr/local/bin/
WORKDIR /tmp/work

CMD xfoil
