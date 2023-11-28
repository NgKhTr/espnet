#!/usr/bin/env bash

set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
SECONDS=0

stage=-1
stop_stage=1

log "$0 $*"
. utils/parse_options.sh

if [ $# -ne 0 ]; then
    log "Error: No positional arguments are required."
    exit 2
fi

. ./db.sh
. ./path.sh
. ./cmd.sh

# t o day nha
log "stage 0: Data preparation"
mkdir -p data/{train_nodev, train_dev, test}
python3 local/process_data.py

log "Successfully finished. [elapsed=${SECONDS}s]"