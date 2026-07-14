#!/usr/bin/env bash
# Needs to be executed as root
#
# Usage: ./profile.sh <output_power_measurement.csv> <command> [args...]
#
# TODOs
## Arg to set polling frequency
##
 
set -euo pipefail
 
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <output_power_measurement.csv> <command> [args...]" >&2
    exit 1
fi
 
OUTPUT_CSV="$1"
shift

# Remaining args ("$@") are the command to profile
 
"$@" &
TARGET_PID=$!
echo "Target PID: $TARGET_PID"
echo "Command: $*"
echo "Output CSV: $OUTPUT_CSV"
 
# JoularCore (profiles CPU usage and power)
joularcore -p "$TARGET_PID" -f "$OUTPUT_CSV"/power.csv &
JOULAR_PID=$!
 
# Memory Activity (measures memory every second)
# perf stat -p $TARGET_PID -e cycles,instructions,cache-references,cache-misses,page-faults,context-switches -I 1000 -o perf_measurement.txt &
# PERF_PID=$!
 
wait "$TARGET_PID"
kill "$JOULAR_PID" 2>/dev/null || true
#kill $PERF_PID 2>/dev/null
#kill $MEM_PID 2>/dev/null
echo "Done. Outputs: $OUTPUT_CSV, perf_measurement.txt, memory_measurement.csv"
