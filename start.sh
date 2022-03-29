#!/bin/bash


envFile=env.sh

if [[ ! -f $envFile ]]; then
    sudo cp setup-env.sh $envFile
fi

# 显示菜单
tput clear
tput civis

w=60
cols=`tput cols`

if [ $cols -lt 60 ]
then
    echo "the windows is too small to show the UI"
    exit 1
fi

left=`expr $cols - $w`
left=`expr $left / 2`

pre=""
space=" "
for i in $(seq 1 $left)
do
    pre="${pre}${space}"
done

tput clear

echo -e "${pre}\033[36m+\033[36m*********************************************************\033[36m+"
echo -e "${pre}\033[36m|\033[34m  _____           _        _     _         ____       _  \033[36m|"
echo -e "${pre}\033[36m|\033[34m |  __ \         | |      | |   | |       / __ \     | | \033[36m|"
echo -e "${pre}\033[36m|\033[34m | |__) |__  _ __| |_ __ _| |__ | | ___  | |  | |    | | \033[36m|"
echo -e "${pre}\033[36m|\033[34m |  ___/ _ \| '__| __/ _  | '_ \| |/ _ \ | |  | |_   | | \033[36m|"
echo -e "${pre}\033[36m|\033[34m | |  | (_) | |  | || (_| | |_) | |  __/ | |__| | |__| | \033[36m|"
echo -e "${pre}\033[36m|\033[34m |_|   \___/|_|   \__\__,_|_.__/|_|\___|  \____/ \____/  \033[36m|"
echo -e "${pre}\033[36m|\033[34m ======================================================= \033[36m|"
echo -e "${pre}\033[36m|\033[34m                                                         \033[36m|"
echo -e "${pre}\033[36m|\033[35m    copyright @ Portable Online Judge Team      (v0.1.0) \033[36m|"
echo -e "${pre}\033[36m|\033[35m    (https://github.com/PortableOJ)                      \033[36m|"
echo -e "${pre}\033[36m|\033[34m                                                         \033[36m|"
echo -e "${pre}\033[36m|\033[31m     Open source based on GNU GENERAL PUBLIC LICENSE     \033[36m|"
echo -e "${pre}\033[36m+\033[36m*********************************************************\033[36m*"
echo -e "\033[0m"

line=15
col=`expr ${left} + 10`
select=0

showOption() {
    tput cup `expr ${line} + $1` ${col}
    if [[ $1 == $select ]]
    then
        echo -en " \033[35m*\033[0m "
    else
        echo -n "   "
    fi
    echo $2
}

while [[ true ]]; do
    showOption 0 "(re)Start a Server with a Judge."
    showOption 1 "(re)Start a Server without Judge."
    showOption 2 "(re)Start a remote Judge."
    showOption 3 "Update deploy shell and restart."
    showOption 4 "Do nothing and quit."

    tput cup `expr ${line} + 6` `expr ${col} - 3`
    echo -e "(use 'w/s' to select, use 'enter' to confirm)"

    read -sn1 action
    if [ -z $action ]
    then
        break
    fi
    case $action in
        w | W)
            if [[ $select -gt 0 ]]
            then
                select=`expr ${select} - 1`
            fi
            ;;
        s | S)
            if [[ $select -lt 4 ]]
            then
                select=`expr ${select} + 1`
            fi
            ;;
    esac
done

tput cnorm
tput clear

# 执行命令

serverFile=./start-server.sh

case $select in
    0)
        sudo chmod +x $serverFile
        $serverFile Y
        ;;
    1)
        sudo chmod +x $serverFile
        $serverFile N
        ;;
    3)
        sudo git pull origin master
        ./start
        ;;
    4)
        ;;
esac
