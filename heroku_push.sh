#!/usr/bin/expect -f

#call heroku auth
set git [lindex $argv 0]
set timeout 60

spawn $git push --force heroku master

expect {
    "(yes/no)?" {
        send -- "yes"
        send -- "\r"
    }
    timeout{
        exit
    }
    eof{
        exit
    }
}