FROM alpine:edge as builder

RUN apk update \
    && apk upgrade

ENV BUILDDEP gcc libc-dev py3-pip openssl-dev zlib-dev jpeg-dev libffi-dev python3-dev py3-virtualenv make git g++ cmake py3-cffi py3-future

RUN apk add $BUILDDEP

RUN git clone https://gitlab.matrix.org/matrix-org/olm
WORKDIR /olm
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DCMAKE_BUILD_TYPE=None \
          -DCMAKE_C_FLAGS="${CFLAGS} ${CPPFLAGS}" \
          -DCMAKE_CXX_FLAGS="${CXXFLAGS} ${CPPFLAGS}" \
          -B build
RUN cmake --build build
WORKDIR /olm/python
RUN python3 setup.py build

WORKDIR /olm/build
RUN make install

RUN virtualenv -p python3 /synapse && \
    source /synapse/bin/activate

WORKDIR /olm/python
RUN pip install -e .

RUN pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install cffi future && \
    pip install matrix-synapse && \
    pip install heisenbridge && \
    pip install mautrix-telegram[all] mautrix-facebook[all] mautrix-googlechat[all]

# ADD scripts/run.sh /

# ENTRYPOINT ["/run.sh"]