# Create build image
FROM python:3.11-slim as build-mpython

ENV BUILD_VERBOSE 1
COPY ./micropython/ /usr/local/src/micropython
WORKDIR /usr/local/src/micropython
RUN <<EOS
echo "### install build tools"
apt-get update
apt-get install -y make build-essential libreadline-dev libffi-dev pkg-config
echo "### build for unix port standard"
source tools/ci.sh && ci_unix_standard_build
echo "### run main test suite"
source tools/ci.sh && ci_unix_standard_run_tests
tests/run-tests.py --print-failures
echo "### install"
cd ports/unix
make install
EOS

CMD /usr/local/bin/micropython