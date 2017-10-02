#!/bin/sh

test1='Seccomp_NO=1 ./do'
test2='Seccomp_NO=1  CFLAGS="-s -static -Wall -mfpu=neon-vfpv4" ./do'
test3='Seccomp_NO=1  CFLAGS="-s -static -Wall -mfloat-abi=hard" ./do'
test4='Seccomp_NO=1  CFLAGS="-s -static -Wall -mfpu=neon-vfpv4 -mfloat-abi=hard" ./do'
test5='Seccomp_NO=1  CFLAGS="-s -static -Wall -march=armv7-a -mtune=cortex-a7" ./do'
test6='Seccomp_NO=1  CFLAGS="-s -static -Wall -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4" ./do'
test7='Seccomp_NO=1  CFLAGS="-s -static -Wall -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard" ./do'
test8='Seccomp_NO=1  CFLAGS="-s -static -Wall -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard  -marm" ./do'
test9='Seccomp_NO=1  CFLAGS="-s -static -Wall -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -fomit-frame-pointer -marm" ./do'


test10='Seccomp_NO=1  CFLAGS="-s -static -Wall -march=armv7-a -mtune=cortex-a7 -fomit-frame-pointer -marm" ./do'
test11='Seccomp_NO=1  CFLAGS="-s -static -Wall -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4 -fomit-frame-pointer -marm" ./do'



cd /opt
mkdir test
cd test

service cjdns stop


for number in 1 2 3 4 5 6 7 8 9 10 11
do

  cd /opt/test

  killall cjdroute


  echo Preparing Compile for Test $number
  #compile
  git clone https://github.com/cjdelisle/cjdns.git cjdns$number
  cd cjdns$number
  git checkout cjdns-v19.1
  eval y='$test'$number

  echo Compiling $y
  eval $y
  echo $y  > /opt/test/cjdns$number.log


  for testing in 1 2 3 4 5
  do
    echo Test $testing
    x=`./cjdroute --bench`
    kbps=`echo "$x"  | grep Benchmark\ salsa20  | awk '{print $8}'`
    pps=`echo "$x" | grep Benchmark\ Switching | awk '{print $8}'`
    echo $kbps kbps $pps pps  >> /opt/test/cjdns$number.log
  done

echo ""

done
