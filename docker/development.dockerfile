# Create build image
FROM python:3.11-slim as base-image 

WORKDIR /root
RUN echo "now building..." && \
    apt update && apt upgrade -y && \
    apt install -y build-essential libreadline-dev libffi-dev git pkg-config gcc-arm-none-eabi libnewlib-arm-none-eabi


FROM base-image as clone-mpython
WORKDIR /usr/local/src
RUN git clone --depth=1 --recurse-submodules https://github.com/micropython/micropython.git

FROM clone-mpython as build-mpython
WORKDIR /usr/local/src/micropython/
RUN cd mpy-cross && \
    make && \
    cd .. && \
    cd ports/unix && \
    make submodules && \
    make && \
    make test_full && \
    make install && \
    make clean && \
    cd ../.. && \
    cd mpy-cross && \
    make clean

CMD /usr/local/bin/micropython