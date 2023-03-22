#!/bin/bash

# 设置关键字
keyword="IOPS"

# 查找所有文件
files=$(find ./$1 -type f | sort)

# 输出表头
echo "        文件名         |  IOPS |  BW  |lat-unit|lat-min|lat-max|lat-avg|lat-stdev|99%lat|99.9%lat|cpu-usr|cpu-sys|cpu-ctx"
echo "-----------------------|-------|------|--------|-------|-------|-------|---------|------|--------|-------|-------|-------"

# 在每个文件中查找关键字
for file in $files; do
    matches=$(grep -E 'IOPS=([0-9.]*[kK],|[0-9.]*[kK,])| lat \([um]sec\):|\| 99.00th=\[[ 0-9.]*\],| cpu          :' "$file")
    if [ -n "$matches" ]; then
    	iops=$(echo "$matches" | grep -oE 'IOPS=([0-9.]*[kK],|[0-9.]*[kK,])' | sed 's/IOPS=//'|sed 's/,//')
        bw=$(echo "$matches" | grep -oE 'BW=([0-9.]*[kK],|[0-9.]*[MiB])' | sed 's/BW=//')
        lat_unit=$(echo "$matches" | grep -oE 'lat \([um]sec' | sed 's/lat (//')
    	lat_min=$(echo "$matches" | grep -o 'min=[0-9.]*,' | sed 's/min=//'| sed 's/,//')
        lat_max=$(echo "$matches" | grep -o 'max=[0-9.Kk]*,' | sed 's/max=//'| sed 's/,//')
        lat_avg=$(echo "$matches" | grep -o 'avg=[0-9.Kk]*,' | sed 's/avg=//'| sed 's/,//')
        lat_stdev=$(echo "$matches" | grep -o 'stdev=[0-9.]*' | sed 's/stdev=//')
        lat_in_99=$(echo "$matches" | grep -o '99.00th=\[[ 0-9.]*\]' | sed 's/99.00th=\[//'| sed 's/\]//')
        lat_in_999=$(echo "$matches" | grep -o '99.90th=\[[ 0-9.]*\]' | sed 's/99.90th=\[//'| sed 's/\]//')
        cpu_usr=$(echo "$matches" | grep -o 'usr=[0-9.%]*' | sed 's/usr=//')
        cpu_sys=$(echo "$matches" | grep -o 'sys=[0-9.%]*' | sed 's/sys=//')
        cpu_ctx=$(echo "$matches" | grep -o 'ctx=[0-9.%]*' | sed 's/ctx=//')
    	printf "%s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s \n" "${file##*/}"  "$iops" "$bw" "$lat_unit" "$lat_min" "$lat_max" "$lat_avg" "$lat_stdev" "$lat_in_99" "$lat_in_999" "$cpu_usr" "$cpu_sys" "$cpu_ctx"
        # printf "%s | %s | %s \n" "${file##*/}"  "$matches" "$bw"
    fi
done