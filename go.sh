#!/usr/bin/env bash
cd $1
activate
cpl
status
logp | awk 'NR==1'


