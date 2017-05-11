FROM ubuntu

RUN apt-get update && \
    apt-get install -y cmake libopal-dev g++ && \
    rm -rf /var/lib/apt/lists/*

COPY . /tmp/sipcmd
WORKDIR /tmp/sipcmd

RUN cmake . && \
    make && \
    make install

ENTRYPOINT "/usr/local/bin/sipcmd"

CMD [ 'sipcmd' ]
