# opendkim_deploy
 an opendkim edit,deploy, and test send script.
### how to use
### important: saltstack required (Master node and minion node)
1. run opendkim_op.sh , this will add/edit the opendkim config file(SigningTable,KeyTable,TrustedHosts)
``` bash opendkim_op.sh $1(domain) $2(replaced domain if is need) ```
2. run opendkim_deploy.sh , this will deploy the config file to the vm in list.(list rule is in script.)
``` bash opendkim_deploy.sh  ```
3. run opendkim_send.sh , testing the result with sending email, this may need to check the mail and run mailer(find example mailer code to use).
``` bash opendkim_send.sh $1(domain to send) ```

