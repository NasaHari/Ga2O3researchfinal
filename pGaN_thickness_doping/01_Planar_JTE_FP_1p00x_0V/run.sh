#!/bin/bash
export SYNOPSYS=/home/tools/synopsys
export LM_LICENSE_FILE=27000@10.8.8.15
export PATH=$SYNOPSYS/bin:$PATH
cd "$(dirname "$0")"
sdevice rev.cmd > rev.stdout 2>&1
