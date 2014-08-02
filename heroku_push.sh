#!/usr/bin/expect -f

#call heroku auth
set git [lindex $argv 0]
set force [lindex $argv 1]

if {$force == "force"} {
    spawn $git push --force heroku master
} else {
    spawn $git push heroku master
}


expect {
    "(yes/no)?" {
        send -- "yes"
        send -- "\r"
    }
}