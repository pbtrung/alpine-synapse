FROM alpine:edge

RUN apk update \
    && apk upgrade

ENV BUILDDEP gcc libc-dev py3-pip openssl-dev zlib-dev jpeg-dev libffi-dev python3-dev py3-virtualenv make

ENV RUNDEP libjpeg python3

RUN apk add $BUILDDEP

RUN virtualenv -p python3 /synapse && \
    source /synapse/bin/activate && \
    pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install https://github.com/matrix-org/synapse/tarball/master

RUN apk del --purge $BUILDDEP
RUN apk add $RUNDEP

# ADD scripts/run.sh /

# ENTRYPOINT ["/run.sh"]