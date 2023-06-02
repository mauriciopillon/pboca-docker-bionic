#!/bin/bash
## Versão de 01/06/2023
## modo de uso: sh bc-autojudge-paa
## sugere-se o lançamento do script em uma screen

DIR='/nishome/autojudge/autojudge-bin/'
LOGs=$DIR'logs/bpaa-autojudgev2.log'
export PATH=/nishome/autojudge/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/jdk1.8.0_131/bin:/nishome/autojudge/autojudge-bin//bin:
export LD_LIBRARY_PATH=:/nishome/autojudge/autojudge-bin//lib

while true; do 
     date
     date >> $LOGs 2>&1
     cd $DIR/bpaa/
     $DIR/bin/php private/autojudging.php >> $LOGs 2>&1
     echo "AutoJudge restart .." >> $LOGs 2>&1
     sleep 5m
done
