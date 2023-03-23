#!/bin/bash
## Versão de 17/08/2022
## modo de uso: sh bc-autojudge <bsdi/bpaa>
## sugere-se o lançamento do script em uma screen
## screen -S sdi
## screen -list
## screen -r sdi

if [ $1 = "bsdi" ]
then
  porta=5433 
else
  porta=5432
fi

while true; do 
     date
     semele=`ps -edf | grep "ssh -fN semele" | wc -l`
     if [ $semele -ne 2 ] 
     then
       echo "Reconectando: ssh -fN semele"
       ssh -fN semele
     fi
     nc=`lsof -i tcp | grep $porta | grep ESTABLISHED | wc -l`
     if [ $nc -ne 2 ]
     then
	echo "AutoJudge offline ..."
  	nc2=`lsof -i tcp | grep $porta | grep LISTEN | wc -l`
  	if [ $nc2 -ne 2 ] 
  	then
  	   echo "Reestabelecendo conexão ssh ..."
	   echo "ssh -fN "$1 
	   ssh -fN $1 
  	fi
	echo "Lançando AutoJudge "$1
  	cd /root/$1/src 
  	sudo php private/autojudging.php
      else 
         echo "AutoJudge OK"
      fi
      sleep 5m
done
