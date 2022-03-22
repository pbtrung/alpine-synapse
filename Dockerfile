FROM alpine:edge

RUN apk update && \
    apk upgrade

ENV BUILDDEP gcc libc-dev py3-pip openssl-dev zlib-dev jpeg-dev libffi-dev python3-dev py3-virtualenv make git g++ cmake py3-numpy py3-cffi py3-future py3-wheel

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

WORKDIR /olm/python
RUN python3 setup.py install --optimize=1 --skip-build

RUN pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install matrix-synapse && \
    pip install mautrix-telegram[all] mautrix-facebook[all] mautrix-googlechat[all]

WORKDIR /

RUN rm -rf /olm
RUN rm -rf /root/.cache/pip

RUN apk del --purge $BUILDDEP
ENV RUNDEP libjpeg python3 tini py3-numpy py3-cffi py3-future
RUN apk add $RUNDEP

EXPOSE 8008/tcp 8448/tcp

VOLUME /data

COPY run.sh /

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/run.sh"]