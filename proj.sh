#!/bin/bash

source ~/projects/.state

while test $# -gt 0; do
        case "$1" in
                -n|--new)
                        name=$2
                        root=~/projects/$name
                        mkdir $root
                        mkdir $root/spec
                        mkdir $root/ios
                        mkdir $root/android
                        mkdir $root/python
                        mkdir $root/python/$name
                        virtualenv $root/python
                        echo "name=$name" > ~/projects/.state
                        cd $root
                        git init
                        break
                        ;;
                -s|--switch)
                        name=$2
                        cd ~/projects/$name
                        clear;pwd;ls
                        git status
                        echo $name > ~/projects/.state
                        break
                        ;;
                a|android)
                        cd ~/projects/$name/android
                        clear;pwd;ls
                        git status
                        break
                        ;;
                i|ios)
                        cd ~/projects/$name/ios
                        clear;pwd;ls
                        git status
                        break
                        ;;
                p|python)
                        cd ~/projects/$name/python/$name
                        clear;pwd;ls
                        git status
                        . bin/activate &>/dev/null; . ../bin/activate &>/dev/null
                        break
                        ;;
                s|spec)
                        cd ~/projects/$name/spec
                        clear;pwd;ls
                        git status
                        break
                        ;;
                
        esac
done
