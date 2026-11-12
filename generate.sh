#!/bin/bash
# Computes the transport tables of all the media at once (run from this directory):
#   ./generate.sh
# Each mixture uses JOBS processes (its field nodes split); the total (mixtures x JOBS) should not exceed the
# cores of the machine (nproc). The concentrations of a mixture go to the same file in data/ (ArIso.root,
# NeIso.root; the writes are locked). Each log goes to <medium>.log; the tables already in a file are
# skipped.
JOBS=${JOBS:-25}

run() {  # run <log> <config> [--set name=value ...]
    local log=$1
    shift
    restGarfield "$@" --jobs "$JOBS" 2>&1 | tee "$log.log" > /dev/null &
}

for iso in 1 2 5 10; do
    run Ar$((100 - iso))_iC4H10_$iso ArIso.yaml --set isobutane=$iso --set argon=$((100 - iso))
    run Ne$((100 - iso))_iC4H10_$iso NeIso.yaml --set isobutane=$iso --set neon=$((100 - iso))
done
run Ne49_Xe49_iC4H10_2 NeXeIso.yaml

wait
echo "Done: $(ls data/*.root)"
