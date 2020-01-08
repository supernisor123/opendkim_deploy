#!/bin/bash

opendkim_domain=${1};
list=$(cat sale_list);
c=0;
#edited template
for i in $list;
do
        if [[ $(($c % 10)) == 0 ]] && [ $c != 0 ];
        then
                echo "now is $c times, sleep 300 second"
                sleep 300
        fi
#get ip and send mail
        ip=`curl -L -d "vm_id=$i" "https://script.google.com/macros/s/customid/exec"`
        echo $ip
        c=$((c + 1))
        echo $c

salt "sendvm*" cmd.run "php /home/dannyli/test2/mailer.php $i $ip $opendkim_domain"

done
