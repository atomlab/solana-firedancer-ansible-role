FROM debian:12-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y --no-install-recommends \
        git \
        curl \
        clang \
        ca-certificates 

# Install Rust
ARG RUST_VERSION=1.87.0
RUN curl --proto '=https' --tlsv1.2 -sSf -o rustup-init.sh https://sh.rustup.rs && \
    chmod +x rustup-init.sh && \
    ./rustup-init.sh -y --default-toolchain ${RUST_VERSION} --profile minimal && \
    rm rustup-init.sh

# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustc --version && cargo --version

WORKDIR /opt/src

# Default can be overridden on commandline or in docker-compose file
ARG GITTAG
ENV RUST_LOG="trace"
ENV SWC_DEBUG=1

RUN git clone --recurse-submodules https://github.com/firedancer-io/firedancer.git && \
    cd ./firedancer && git checkout ${GITTAG}

RUN cd ./firedancer && \
    rust_toolchain=$(grep "channel" agave/rust-toolchain.toml | awk '{print $NF}' | tr -d '"') && \
    rustup toolchain uninstall ${rust_toolchain}-x86_64-unknown-linux-gnu || true && \
    rustup toolchain install ${rust_toolchain}-x86_64-unknown-linux-gnu --profile minimal && \
    rustup default ${rust_toolchain}-x86_64-unknown-linux-gnu && \
    rustc --version && cargo --version

RUN cd ./firedancer && \
    FD_AUTO_INSTALL_PACKAGES=1 DEBIAN_FRONTEND=noninteractive ./deps.sh fetch check install

RUN cd ./firedancer && make -j fdctl

# Set up release container
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
