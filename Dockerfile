FROM ubuntu

RUN apt-get update && \
    apt-get install -y --no-install-recommends cmake make build-essential libopal-dev libpt-dev gcc g++

COPY . /sipcmd
WORKDIR /sipcmd

RUN cmake . && \
    make && \
    make install

ENTRYPOINT ["/usr/local/bin/sipcmd"]
