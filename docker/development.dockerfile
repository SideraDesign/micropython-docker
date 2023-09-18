# Create build image
FROM python:3.11-slim as clone-mpython

WORKDIR /root
RUN echo "now building..." && \
    apt update && \
    apt install -y tree && \
    tree -L 2 /usr/local/src/

CMD /bin/bash