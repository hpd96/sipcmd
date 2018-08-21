#!/usr/bin/env bash
docker run --cap-add=sys_nice --rm sipcmd -P sip -t 60 -w sip.zadarma.com -u $1 -c $2 -x $3