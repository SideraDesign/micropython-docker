# Create build image
FROM python:3.11-slim as clone-mpython

WORKDIR /root
COPY micropython/ /usr/local/src/
RUN echo "now building..." && \
    apt update && apt upgrade -y && \
    apt install -y build-essential libreadline-dev libffi-dev git pkg-config make

FROM clone-mpython as build-mpython
# WORKDIR /usr/local/src/micropython/
WORKDIR /usr/local/src/micropython/mpy-cross
RUN make
WORKDIR /usr/local/src/micropython/ports/unix
RUN make submodules
RUN make
RUN make test_full
RUN make install
RUN make clean
RUN cd ../..
RUN cd mpy-cross
RUN make clean
# RUN cd mpy-cross && \
#     make && \
#     cd .. && \
#     cd ports/unix && \
#     make submodules && \
#     make && \
#     make test_full && \
#     make install && \
#     make clean && \
#     cd ../.. && \
#     cd mpy-cross && \
#     make clean

CMD /usr/local/bin/micropython