#FROM ubuntu:20.04 as builder
FROM debian:12-slim AS builder

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends git curl clang ca-certificates

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /opt/src

# Default can be overridden on commandline or in docker-compose file
ARG GITTAG
RUN git clone --recurse-submodules https://github.com/firedancer-io/firedancer.git && \
    cd ./firedancer && git checkout ${GITTAG}
RUN	cd ./firedancer && \
    FD_AUTO_INSTALL_PACKAGES=1 DEBIAN_FRONTEND=noninteractive ./deps.sh fetch check install

RUN cd ./firedancer && make -j fdctl

# Set up release container
#FROM ubuntu:20.04 AS release
FROM debian:12-slim AS release

RUN useradd -s /bin/bash -m -d /opt/firedancer firedancer && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends bzip2 curl ca-certificates

COPY entrypoint.sh /
COPY --from=builder /opt/src/firedancer/build/native/gcc/bin /opt/firedancer/bin
COPY --from=builder /opt/src/firedancer/src/app/fdctl/config /opt/firedancer/config

ENV FD_LOG_PATH="/opt/firedancer/log"
ENV PATH="/opt/firedancer/bin:$PATH"

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["tail", "-f", "/dev/null"]

