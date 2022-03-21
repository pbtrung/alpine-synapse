FROM alpine:edge as builder

RUN apk update \
    && apk upgrade

ENV BUILDDEP gcc libc-dev py3-pip openssl-dev zlib-dev jpeg-dev libffi-dev python3-dev py3-virtualenv make git g++ cmake py3-numpy

RUN apk add $BUILDDEP

RUN git clone https://gitlab.matrix.org/matrix-org/olm
WORKDIR /olm
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DCMAKE_BUILD_TYPE=None \
          -DCMAKE_C_FLAGS="${CFLAGS} ${CPPFLAGS}" \
          -DCMAKE_CXX_FLAGS="${CXXFLAGS} ${CPPFLAGS}" \
          -B build
RUN cmake --build build

WORKDIR /olm/build
RUN make install

RUN virtualenv -p python3 /synapse && \
    source /synapse/bin/activate

RUN pip install --upgrade cffi && \
    pip install --upgrade future

WORKDIR /olm/python
RUN python3 setup.py build
RUN python3 setup.py install --optimize=1 --skip-build

RUN pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install matrix-synapse && \
    pip install heisenbridge && \
    pip install mautrix-telegram[all] mautrix-facebook[all] mautrix-googlechat[all]

FROM alpine:edge

RUN apk update \
    && apk upgrade

ENV RUNDEP libjpeg-turbo python3 py3-numpy
RUN apk add $RUNDEP

RUN mkdir /synapse
COPY --from=builder /synapse /synapse

# ADD scripts/run.sh /

# ENTRYPOINT ["/run.sh"]