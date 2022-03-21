FROM alpine:edge as builder

RUN apk update \
    && apk upgrade

ENV BUILDDEP gcc libc-dev py3-pip openssl-dev zlib-dev jpeg-dev libffi-dev python3-dev py3-virtualenv make

RUN apk add $BUILDDEP

RUN virtualenv -p python3 /synapse && \
    source /synapse/bin/activate && \
    pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install https://github.com/matrix-org/synapse/tarball/master

FROM alpine:edge

RUN apk update \
    && apk upgrade

ENV RUNDEP libjpeg python3
RUN apk add $RUNDEP

RUN mkdir /synapse
COPY --from=builder /synapse /synapse
RUN source /synapse/bin/activate

# ADD scripts/run.sh /

# ENTRYPOINT ["/run.sh"]