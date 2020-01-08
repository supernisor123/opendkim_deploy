#!/bin/bash

level1=$(cat ./level1/level1);
level2=$(cat ./level2/level2);


#edited template
echo "level1"
for i in $level1;
do
        if  [ -z "$level1all" ];then
                level1all=$i;
                continue;
        fi
        level1all="$level1all|$i"
done

echo "$level1all is going to deploy."
#push template to level1
echo "salt-cp -E '$level1all'  ./opendkim_script/level2/KeyTable /etc/opendkim/KeyTable"

echo "salt-cp -E '$level1all' ./opendkim_script/level2/SigningTable /etc/opendkim/SigningTable"

echo "salt-cp -E '$level1all' ./opendkim_script/level2/TrustedHosts /etc/opendkim/TrustedHosts"
 
echo "salt -E '$level1all' cmd.run 'service opendkim stop ;sleep 3; service opendkim start'"




for j in $level2;
do
        if  [ -z "$level2all" ];then
                level2all=$j;
                continue;
        fi
        level2all="$level2all|$j"
done
echo "$level2all is going to deploy."
echo "salt-cp -E '$level2all'  ./opendkim_script/level2/KeyTable /etc/opendkim/KeyTable"

echo "salt-cp -E '$level2all' ./opendkim_script/level2/SigningTable /etc/opendkim/SigningTable"

echo "salt-cp -E '$level2all' ./opendkim_script/level2/TrustedHosts /etc/opendkim/TrustedHosts"
 
echo "salt -E '$level2all' cmd.run 'service opendkim stop ;sleep 3; service opendkim start'"

