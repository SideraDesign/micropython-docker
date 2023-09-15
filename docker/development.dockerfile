# Create build image
FROM python:3.11-slim as clone-mpython

WORKDIR /root
COPY micropython/ /usr/local/src/micropython
RUN echo "now building..." && \
    apt update && \
    apt install -y build-essential libreadline-dev libffi-dev git pkg-config make tree && \
    tree -L 2 /usr/local/src/

FROM clone-mpython as build-mpython
WORKDIR /usr/local/src/micropython
WORKDIR /usr/local/src/micropython/
RUN <<EOS
cd mpy-cross
make
cd ..
cd ports/unix
make submodules
make
make test_full
make install
make clean
cd ../..
cd mpy-cross
make clean
cd mpy-cross
EOS

CMD /usr/local/bin/micropython