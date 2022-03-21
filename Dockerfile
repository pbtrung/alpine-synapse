FROM alpine:edge as builder

RUN apk update \
    && apk upgrade

ENV BUILDDEP gcc libc-dev py3-pip openssl-dev zlib-dev jpeg-dev libffi-dev python3-dev py3-virtualenv make git g++ cmake

RUN apk add $BUILDDEP

RUN git clone https://gitlab.matrix.org/matrix-org/olm
WORKDIR /olm
RUN ls -la
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DCMAKE_BUILD_TYPE=None \
          -DCMAKE_C_FLAGS="${CFLAGS} ${CPPFLAGS}" \
          -DCMAKE_CXX_FLAGS="${CXXFLAGS} ${CPPFLAGS}" \
          -B build
RUN cmake --build build
RUN cd python
RUN python3 setup.py build

# ADD scripts/run.sh /

# ENTRYPOINT ["/run.sh"]