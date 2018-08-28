#!/bin/bash

#############list to install
#sublime text
#jq
#git
#curl
#wget
#unzip
#alias cls
#unrar
#docker
#vagrant
#virtualbox
#java
#jadx
#asciinema


#####################################################
#color
RED="31m"      # info 
GREEN="32m"    # success 
YELLOW="33m"   # exsist 
BLUE="36m"     # install 
colorEcho(){
    COLOR=$1
    echo -e "\033[${COLOR}${@:2}\033[0m" | tee -a autoLog
}
#####################################################
#judge
isNull(){
	if [ ! -n "$1" ]; then
  		echo 'N'
	else
  		echo 'Y'
	fi 
}
isInstalled(){
	res=`which $1`
	ret=`isNull $res`
	echo $ret
}
isInalias(){
	res=`cat ~/.bashrc | grep "$1"`
	ret=`isNull $res`
	echo $ret
}
#####################################################
#set alias
setalias(){
	if [ `isInalias cls` = "N" ];then
		colorEcho ${BLUE} "`date` ----- add alias: cls "
		echo "alias cls='printf \"\033c\"'" >> ~/.bashrc
	else
		colorEcho ${YELLOW} "`date` ----- alias: cls alerdy exsists " 
	fi
}
#####################################################
#apt install
aptInstall(){
	if [ `isInstalled $1` = "N" ];then
		colorEcho ${BLUE} "`date` ----- apt install: $1"
		sudo apt-get install $1 -y >> autoLog
	else
		colorEcho ${YELLOW} "`date` ----- $1 alerdy installed"
	fi
}
#####################################################
touch autoLog
colorEcho ${RED} "`date` -----  update system "
sudo apt-add-repository ppa:zanchey/asciinema -y >> autoLog
sudo apt-get update -y >> autoLog
sudo apt-get upgrade -y >> autoLog
setalias
aptInstall git
aptInstall jq
aptInstall wget
aptInstall unzip
aptInstall unrar
aptInstall asciinema
if [ `isInstalled vagrant` = "N" ];then
	colorEcho ${BLUE} "`date` ----- install: vagrant"
	wget https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb >> autoLog
	sudo dpkg -i vagrant_2.1.2_x86_64.deb
else
	colorEcho ${YELLOW} "`date` ----- vagrant alerdy installed"
fi
if [ `isInstalled java` = "N" ];then
	colorEcho ${BLUE} "`date` ----- install: java"
	sudo apt-get install openjdk-7-jdk -y >> autoLog
else
	colorEcho ${YELLOW} "`date` ----- java alerdy installed"
fi
