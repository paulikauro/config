#!/bin/sh
IFS= read -r -s -p 'Password: ' password
echo
IFS= read -r -s -p 'Confirm:  ' confirm
echo
if [ "$password" != "$confirm" ]; then
    echo "Passwords do not match"
    exit
fi
echo $password | mkpasswd -m SHA-512 -s

