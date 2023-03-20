#! /usr/bin/expect


cat > temp.exp << EOF
#! /bin/expect
set timeout 0
spawn yum install vim
expect "Yes or No:"
send "Y\\r"
interact
EOF
