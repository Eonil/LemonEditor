#!/usr/bin/expect -f

#call heroku auth
set git [lindex $argv 0]

spawn $git push --force heroku master

expect {
    "(yes/no)?" {
        send -- "yes"
        send -- "\r"
    }
}

expect EOF