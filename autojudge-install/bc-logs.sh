#!/bin/bash

DIR=/nishome/autojudge/autojudge-bin/bocatmp/
sshportal="paa.portal"

logflag=`ls -la $DIR/*.paa 2> /dev/null | wc -l`
if [ $logflag -gt 1 ] 
then
        ls -l $DIR/*.paa
        ssh $sshportal "mkdir -p logs"
        scp $DIR/*.paa $sshportal:logs/
        rm -f $DIR/*.paa
        ssh $sshportal "docker cp ./logs/ pboca-paa_boca_1:/var/www/boca/src/."
        ssh $sshportal "rm -rf logs"
fi
sleep 5m
