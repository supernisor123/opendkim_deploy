#!/bin/bash

domain=$1
n_domain=$2


if [ -z $2 ];
then
   op="add"
else
   op="edit"
fi
if [ -z $1 ];
then
echo "please enter the domain to check is in list or not."

read domain
fi
level1_s=./level1/SigningTable
level1_k=./level1/KeyTable
level1_t=./level1/TrustedHosts

level2_s=./level2/SigningTable
level2_k=./level2/KeyTable
level2_t=./level2/TrustedHosts


sign=($level1_s $level2_s)
key=($level1_k $level2_k)
trust=($level1_t $level2_t)
all=($level1_s $level1_k $level1_t $level2_s $level2_k $level2_t)

for i in "${all[@]}";
do
### if no template , then create.
if [ ! -f "${i}tmp" ]; then
     cp $i ${i}tmp
fi
if [ $op == "edit" ]; then
        a=$(cat $i | grep -w $domain)
        if [ -z "$a" ]; then
                echo "none"
        else
                echo "changed to $n_domain"
                sed -i "s/$domain/$n_domain/g" $i
        fi
fi
done

if [ "$op" == "add" ];then

###sign
for s in "${sign[@]}";
do
if [ -z "$(cat $s|grep $domain)"  ];
then
        echo "domain is not in SigningTable , creating..."
        id=$(cat $s | grep -n "e.lxzmail.com" | head -n 1 | cut -d: -f1)
        sed -i "${id}i*@${domain} 20190125._domainkey.${domain}" $s
        echo "SigningTable $s check:$(cat $s | grep $domain)"
fi
done

###key
for k in "${key[@]}";
do
if [ -z "$(cat $k|grep $domain)" ];
then
        echo "domain is not in KeyTable , creating..."
        echo "20190125._domainkey.$domain $domain:20190125:/etc/opendkim/keys/e.tigerflyapp.tw/20190125.private" >> $k
        echo "KeyTable $k check:$(cat $k | grep $domain)"
fi
done
###trust
for t in "${trust[@]}";
do
if [ -z "$(cat $t|grep $domain)" ];
then
        echo "domain is not in TrustedHosts , creating..."
        echo "$domain" >> $t
        echo "TrustedHost $t check:$(cat $t | grep $domain)"
fi
done


rec=$(salt "rec*" cmd.run "cat /etc/postfix/main.cf | grep $domain"|grep -v "rec")

if [ -z "$rec" ] ; then
echo "no"
salt "rec*" cmd.run "cat /etc/postfix/main.cf | grep -e 'mydestination ='|grep -v '#mydestination' |sed -i \"s/.*e.daf-shoes.com/&, $domain/\" /etc/postfix/main.cf"
salt "rec*" cmd.run "service postfix restart"
fi
echo "plz go to add fbl:https://io.help.yahoo.com/contact/index?y=PROD_POST&token=w5FCchB1dWHZDkMtMbkiWayP5fLB89LEazPpdlu1lUWV4EFNPvMPvBYezMNZYY69sQrgrKm11T8m35XrWQkGPuvSSxp%252FrzhZX%252FeR%252Bh4HRWpdK7%252FmkT4QRzWth1dNT8Lc1pDGlz2h%252BMY%253D&locale=en_US&page=contactform&selectedChannel=email-icon"
fi
