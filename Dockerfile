FROM ubuntu:14.04
WORKDIR /build
# install tools and dependencies
RUN apt-get update && \
        apt-get install -y \
        g++ \
        curl \
        git \
        file \
        binutils

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# show backtraces
ENV RUST_BACKTRACE 1

# show tools
RUN rustc -vV && \
cargo -V && \
gcc -v &&\
g++ -v

# build parity
RUN git clone https://github.com/ethcore/parity && \
        cd parity && \
        git checkout beta && \
        git pull && \
        cargo build --release --verbose && \
        ls /build/parity/target/release/parity && \
        strip /build/parity/target/release/parity

EXPOSE 8545
EXPOSE 8080
       
ENTRYPOINT ["/build/parity/target/release/parity"]