FROM alpine:edge as builder

RUN apk update \
    && apk upgrade

ENV BUILDDEP gcc libc-dev py3-pip openssl-dev zlib-dev jpeg-dev libffi-dev python3-dev py3-virtualenv make

RUN apk add $BUILDDEP

RUN virtualenv -p python3 /synapse && \
    source /synapse/bin/activate && \
    pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install python-olm --extra-index-url https://gitlab.matrix.org/api/v4/projects/27/packages/pypi/simple && \
    pip install matrix-synapse && \
    pip install heisenbridge && \
    pip install mautrix-telegram[all] mautrix-facebook[all] mautrix-googlechat[all]


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