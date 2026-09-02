#!/bin/bash
CMD="tar -xzf pkgs/npm/zod--zod-4.4.3.tgz -C decompressed/"

perf stat -e power/energy-pkg/,power/energy-ram/,task-clock,cycles \
    -o perf_out.txt -- bash -c "
        $CMD &
        PID=\$!
        while kill -0 \$PID 2>/dev/null; do
            echo \"\$(date +%s.%N) \$(grep VmRSS /proc/\$PID/status) \$(cat /proc/\$PID/io | tr '\n' ' ')\" >> sample_log.txt
            sleep 0.1
        done
        wait \$PID
    "
