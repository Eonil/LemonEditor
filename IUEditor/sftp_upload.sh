#!/usr/bin/expect -f

set from [lrange $argv 0 0]
set user [lrange $argv 1 1]
set server [lrange $argv 2 2]
set remoteDirectory [lrange $argv 3 3]
set syncdir [lrange $argv 4 4]
set password [lrange $argv 5 5]

set timeout -1

# now connect to remote UNIX box (ipaddr) with given script to execute
#spawn scp -r $local $remote  $user@$ipaddr:$remotefile
spawn sftp $user@$server:$remoteDirectory
match_max 100000
# Look for passwod prompt
expect {
    "*?assword:*" {
        # Send password aka $password 
        send -- "$password\r"
        # send blank line (\r) to make sure we get back to gui
        send -- "\r"
    }
}
expect "sftp>"
send -- "lcd $from\r"
send -- "\r"
expect "sftp>"
send -- "mkdir $syncdir\r"
send -- "\r"
expect "sftp>"
send -- "put -r $syncdir\r"
send -- "\r"
send -- "quit\r"



expect eof
