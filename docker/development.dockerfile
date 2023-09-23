# Create build image
FROM python:3.11-slim as build-mpython

WORKDIR /root
COPY micropython/ /usr/local/src/micropython
RUN <<EOS
echo "### install build tools"
apt update
apt install -y build-essential libreadline-dev libffi-dev git pkg-config make tree
cd /usr/local/src/micropython
tree -L 2 -a /usr/local/src/
echo "### build modules"
cd mpy-cross
make
cd ..
echo "### build for unix port"
cd ports/unix
make submodules
make
echo "### check and install"
make test_full
make install
EOS

FROM python:3.11-slim
ENV MICROPY_MICROPYTHON /usr/local/bin/micropython
COPY --from=build-mpython /usr/local/bin/micropython /usr/local/bin/micropython
COPY --from=build-mpython /usr/local/src/tests/ /usr/local/bin/src/tests
WORKDIR /usr/local/src/micropython/

CMD /usr/local/bin/micropython