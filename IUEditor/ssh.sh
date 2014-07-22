#!/usr/bin/expect --

# set Variables
set usname [lrange $argv 0 0]
set password [lrange $argv 1 1] 
set ipaddr [lrange $argv 2 2]   
set commands [lrange $argv 3 end]

# now connect to remote UNIX box (ipaddr) with given script to execute

# Set the size of the buffer, and ensure it hasn't been undefined.
match_max 10000
set expect_out(buffer) {}

# Set the timeout before expect assumes the spawn has not responded or lost link
set timeout 60

# now connect to remote UNIX box (ipaddr) with given script to execute

spawn ssh -4 -2 -k -o StrictHostKeyChecking=no $usname@$ipaddr $commands

expect {
                     "*?assword:" {
                               send "$password\r"
                   } "yes/no)?" {
                               send "yes\r"
                               set timeout -1
                   } timeout {
                               exit
                                   } -re . {
                                                           exp_continue
                   } eof {
                               exit
                   }
}

# Keep connection active as long as text is returned to terminal.
expect -re . {  exp_continue } eof { exit }

expect eof
