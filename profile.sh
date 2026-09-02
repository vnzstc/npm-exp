#!/usr/bin/env bash
# Needs to be executed as root
#
# Usage: ./profile.sh <command> [args...]
 
set -euo pipefail
 
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <command> [args...] output">&2
    exit 1
fi


args=("$@")
cmd="${args[@]:1:3}"

if [[ "${args[1]}" == "xz" ]]; then
    cmd="${cmd} > ${args[4]}"
else
    cmd="${cmd} -C ${args[4]}"
fi

## perf stat -a -e power/energy-pkg/,power/energy-ram/,cycles,instructions,cache-references,cache-misses,page-faults,context-switches -o $parent/stat.txt -- $*
perf stat -e power/energy-pkg/,power/energy-ram/ -o "${args[0]}/stat.txt" -- bash -c "$cmd"
echo "${cmd}" >> "${args[0]}/stat.txt" 
