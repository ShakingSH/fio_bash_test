#!/bin/bash

# 在这里修改参数，且在循环的fio命令中修改/dev/md5 以及重定向文件名
numjobs_list=(1 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32)
# iopdepth深度
iodepth_list=(16)
# 读写方式
rw_list=("randwrite" "randread")
# 目标块设备
device=sd
# 软raid or 硬raid
soft_or_hard_ware=sr
# 架构名
arch=sw
# raid级别
raidlevel=raid0
# 测试时间
runtime=60
# Loop over the parameter combinations
for rw in "${rw_list[@]}"
do
  for numjobs in "${numjobs_list[@]}"
  do
    for iodepth in "${iodepth_list[@]}"
    do
      # Run fio
      fio -filename=/dev/$device -direct=1 -iodepth=$iodepth -rw="$rw" -ioengine=libaio -bs=4K -time_based=1 -thread=1 -numjobs="$numjobs" -runtime=$runtime -group_reporting -name=mytest16 > "./res/$arch-$device-$soft_or_hard_ware-$raidlevel-$rw-n$(printf "%02d" $numjobs)-iodepth$(printf "%03d" $iodepth)-runtime$runtime"
    done
  done
done
