#!/usr/bin/expect -f

set user [lrange $argv 0 0] 
set password [lrange $argv 1 1] 
set ipaddr [lrange $argv 2 2]   
set localfile [lrange $argv 3 3]   
set remotefile [lrange $argv 4 4]

set timeout -1   
# now connect to remote UNIX box (ipaddr) with given script to execute
spawn scp -r $localfile $user@$ipaddr:$remotefile
match_max 100000
# Look for passwod prompt
expect "*?assword:*"
# Send password aka $password 
send -- "$password\r"
# send blank line (\r) to make sure we get back to gui
send -- "\r"
expect eof

