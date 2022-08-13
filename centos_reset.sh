#!/bin/bash
#
#********************************************************************
#Author:		    weiow
#QQ: 			    3424538465
#Date: 			    2022-8-13
#FileName：		    reset_centos.sh
#URL: 			    weiow.weiyubo.cn
#Description：		The test script
#Copyright (C): 	2022 All rights reserved
#********************************************************************
. /etc/init.d/functions

centos_version() {
sed -rn 's#^.* ([0-9]+)\..*#\1#p' /etc/redhat-release
}

optimization_sshd(){
sed -i.bak -e 's/#UseDNS no/UseDNS no/' -e 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
action "CentOS`centos_version`SSH已优化完成!"
}

disable_selinux(){
sed -ri.bak 's/^(SELINUX=).*/\1disabled/' /etc/selinux/config
action "CentOS`centos_version`SELinux已禁用,请重新启动系统后才能生效!"
}

set_alias(){
cat >>~/.bashrc <<EOF
alias cdnet="cd /etc/sysconfig/network-scripts"
alias vie0="vim /etc/sysconfig/network-scripts/ifcfg-eth0"
alias scandisk="echo '- - -' > /sys/class/scsi_host/host0/scan;echo '- - -' > /sys/class/scsi_host/host1/scan;echo '- - -' > /sys/class/scsi_host/host2/scan"
EOF
action "CentOS`centos_version`系统别名已设置成功,请重新登陆后生效!"
}

set_vimrc(){
cat >~/.vimrc <<EOF  
set ts=4
set expandtab
set ignorecase
set cursorline
set autoindent
autocmd BufNewFile *.sh exec ":call SetTitle()"
func SetTitle()
	if expand("%:e") == 'sh'
	call setline(1,"#!/bin/bash") 
	call setline(2,"#") 
	call setline(3,"#********************************************************************") 
	call setline(4,"#Author:		    weiow") 
	call setline(5,"#QQ: 			    3424538465") 
	call setline(6,"#Date: 			    ".strftime("%Y-%m-%d"))
	call setline(7,"#FileName：		    ".expand("%"))
	call setline(8,"#URL: 			    weiow.weiyubo.cn")
	call setline(9,"#Description：		The test script") 
	call setline(10,"#Copyright (C): 	".strftime("%Y")." All rights reserved")
	call setline(11,"#********************************************************************") 
	call setline(12,"") 
	endif
endfunc
autocmd BufNewFile * normal G
EOF
action "CentOS`centos_version`vimrc设置完成，请重新系统启动才能生效!"
}

set_mailrc(){
cat >~/.mailrc <<EOF
set from=19661891@qq.com
set smtp=smtp.qq.com
set smtp-auth-user=19661891@qq.com
set smtp-auth-password=hrlnpctmxkpqbjdd
set smtp-auth=login
set ssl-verify=ignore
EOF
action "CentOS`centos_version`mailrc设置完成，请重新登录后才能生效!"
}

set_yum_centos8(){
mkdir /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
cat > /etc/yum.repos.d/base.repo <<EOF
[BaseOS]
name=BaseOS
baseurl=https://mirrors.aliyun.com/centos/\$releasever/BaseOS/\$basearch/os/
        https://mirrors.huaweicloud.com/centos/\$releasever/BaseOS/\$basearch/os/
        https://mirrors.cloud.tencent.com/centos/\$releasever/BaseOS/\$basearch/os/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/BaseOS/\$basearch/os/
        http://mirrors.163.com//centos/\$releasever/BaseOS/\$basearch/os/
        http://mirrors.sohu.com/centos/\$releasever/BaseOS/\$basearch/os/ 
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[AppStream]
name=AppStream
baseurl=https://mirrors.aliyun.com/centos/\$releasever/AppStream/\$basearch/os/
        https://mirrors.huaweicloud.com/centos/\$releasever/AppStream/\$basearch/os/
        https://mirrors.cloud.tencent.com/centos/\$releasever/AppStream/\$basearch/os/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/AppStream/\$basearch/os/
        http://mirrors.163.com/centos/\$releasever/AppStream/\$basearch/os/
        http://mirrors.sohu.com/centos/\$releasever/AppStream/\$basearch/os/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[EPEL]
name=EPEL
baseurl=https://mirrors.aliyun.com/epel/\$releasever/Everything/\$basearch/
        https://mirrors.huaweicloud.com/epel/\$releasever/Everything/\$basearch/
        https://mirrors.cloud.tencent.com/epel/\$releasever/Everything/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/epel/\$releasever/Everything/\$basearch/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-\$releasever

[extras]
name=extras
baseurl=https://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/os/
        https://mirrors.huaweicloud.com/centos/\$releasever/extras/\$basearch/os/
        https://mirrors.cloud.tencent.com/centos/\$releasever/extras/\$basearch/os/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/extras/\$basearch/os/
        http://mirrors.163.com/centos/\$releasever/extras/\$basearch/os/
        http://mirrors.sohu.com/centos/\$releasever/extras/\$basearch/os/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
enabled=1

[centosplus]
name=centosplus
baseurl=https://mirrors.aliyun.com/centos/\$releasever/centosplus/\$basearch/os/
        https://mirrors.huaweicloud.com/centos/\$releasever/centosplus/\$basearch/os/
        https://mirrors.cloud.tencent.com/centos/\$releasever/centosplus/\$basearch/os/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/centosplus/\$basearch/os/
        http://mirrors.163.com/centos/\$releasever/centosplus/\$basearch/os/
        http://mirrors.sohu.com/centos/\$releasever/centosplus/\$basearch/os/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF
dnf clean all
dnf repolist
action "CentOS`centos_version`YUM源设置完成!"
}

set_yum_centos7(){
mkdir /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
cat > /etc/yum.repos.d/base.repo <<EOF
[base]
name=base
baseurl=https://mirrors.aliyun.com/centos/\$releasever/os/\$basearch/ 
        https://mirrors.huaweicloud.com/centos/\$releasever/os/\$basearch/ 
        https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/os/\$basearch/
        http://mirrors.163.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[epel]
name=epel
baseurl=https://mirrors.aliyun.com/epel/\$releasever/\$basearch/
        https://mirrors.huaweicloud.com/epel/\$releasever/\$basearch/
        https://mirrors.cloud.tencent.com/epel/\$releasever/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/epel/\$releasever/\$basearch/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-\$releasever

[extras]
name=extras
baseurl=https://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
        https://mirrors.huaweicloud.com/centos/\$releasever/extras/\$basearch/
        https://mirrors.cloud.tencent.com/centos/\$releasever/extras/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/extras/\$basearch/
        http://mirrors.163.com/centos/\$releasever/extras/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[updates]
name=updates
baseurl=https://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
        https://mirrors.huaweicloud.com/centos/\$releasever/updates/\$basearch/
        https://mirrors.cloud.tencent.com/centos/\$releasever/updates/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/updates/\$basearch/
        http://mirrors.163.com/centos/\$releasever/updates/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[centosplus]
name=centosplus
baseurl=https://mirrors.aliyun.com/centos/\$releasever/centosplus/\$basearch/
        https://mirrors.huaweicloud.com/centos/\$releasever/centosplus/\$basearch/
        https://mirrors.cloud.tencent.com/centos/\$releasever/centosplus/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/centosplus/\$basearch/
        http://mirrors.163.com/centos/\$releasever/centosplus/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/centosplus/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever
EOF
yum clean all
yum repolist
action "CentOS`centos_version`YUM源设置完成!"
}

set_yum_centos6(){
mkdir /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
cat > /etc/yum.repos.d/base.repo <<EOF
[base]
name=base
baseurl=https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/os/\$basearch/
        https://mirrors.aliyun.com/centos-vault/\$releasever.10/os/\$basearch/ 
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[epel]
name=epel
baseurl=https://mirrors.cloud.tencent.com/epel/\$releasever/\$basearch/
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/epel/RPM-GPG-KEY-EPEL-\$releasever

[extras]
name=extras
baseurl=https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/extras/\$basearch/
        https://mirrors.aliyun.com/centos-vault/\$releasever.10/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[updates]
name=updates
baseurl=https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/updates/\$basearch/
        https://mirrors.aliyun.com/centos-vault/\$releasever.10/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[centosplus]
name=centosplus
baseurl=https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/centosplus/\$basearch/
        https://mirrors.aliyun.com/centos-vault/\$releasever.10/centosplus/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever
EOF
yum clean all
yum repolist                                                                                                
action "CentOS`centos_version`YUM源设置完成!"
}

set_yum(){
centos_version | while read ov ;do
	if [ $ov -eq 8 ];then
		set_yum_centos8
	elif [ $ov -eq 7 ];then    
		set_yum_centos7
	else
		set_yum_centos6    
	fi
done
}

centos_minimal_install(){
yum -y install gcc make autoconf gcc-c++ glibc glibc-devel pcre pcre-devel openssl openssl-devel systemd-devel zlib-devel vim lrzsz tree tmux lsof tcpdump wget net-tools iotop bc bzip2 zip unzip nfs-utils man-pages
action "CentOS`centos_version`最小化安装建议安装软件已安装完成!"
}

disable_firewalld(){
systemctl disable --now firewalld &> /dev/null
action "CentOS`centos_version`防火墙Firewall已关闭!"
}

set_sshd_port(){
read -p "请输入端口号:" PORT
sed -i 's/#Port 22/Port '$PORT'/' /etc/ssh/sshd_config
systemctl restart sshd                                                                                               
action "CentOS`centos_version`更改SSH端口号已完成，请重新登录！"
}

set_eth(){
ETHNAME=`ip addr | sed -nr '/^2/s#^.* ([a-z]+[0-9]+).*#\1#p'`
#修改网卡名称配置文件
sed -ri.bak '/^GRUB_CMDLINE_LINUX=/s@"$@ net.ifnames=0"@' /etc/default/grub 
grub2-mkconfig -o /boot/grub2/grub.cfg >& /dev/null
                                     
#修改网卡文件名
mv /etc/sysconfig/network-scripts/ifcfg-${ETHNAME} /etc/sysconfig/network-scripts/ifcfg-eth0
action "CentOS`centos_version`网卡名已修改成功，请重新启动系统后才能生效!"
}

check_ip(){
local IP=$1
VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" >/dev/null; then
	if [ $VALID_CHECK == "yes" ]; then
		echo "IP $IP  available!"
		return 0
	else
		echo "IP $IP not available!"
		return 1
	fi
else
	echo "IP format error!"
	return 1
fi
}

set_ip(){
while true; do
	read -p "请输入IP地址:"  IP
	check_ip $IP
	[ $? -eq 0 ] && break
done
while true; do
	read -p "请输入网关地址:" GATEWAY
	check_ip ${GATEWAY}
	[ $? -eq 0 ] && break
done
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
NAME=eth0
BOOTPROTO=none
ONBOOT=yes
IPADDR=$IP
PREFIX=24
GATEWAY=$GATEWAY
DNS1=223.5.5.5
DNS2=180.76.76.76
EOF
action "CentOS`centos_version`IP地址已修改成功，请重新启动系统后才能生效!"
}

set_eth_ip(){
if [ $(centos_version) -eq 6 ];then 
	set_ip
else
	set_eth
	set_ip
fi
}

set_hostname78(){
read -p "请输入主机名:"  HOST
hostnamectl set-hostname $HOST
action "CentOS`centos_version`主机名设置成功，请重新登录生效!"
}

set_hostname6(){
read -p "请输入主机名:"  HOST
sed -i.bak -r '/^HOSTNAME/s#^(HOSTNAME=).*#\1'$HOST'#' /etc/sysconfig/network
action "CentOS`centos_version`主机名设置成功，请重新登录生效!"
}

set_hostname(){
if [ $(centos_version) -eq 6 ];then 
	set_hostname6
else
	set_hostname78
fi
}

set_centosps1(){
TIPS="action CentOS`centos_version`PS1已设置完成,请重新登录生效!"
while true;do
echo -e "\E[$[RANDOM%7+31];1m"
cat <<EOF
1)31 红色
2)32 绿色
3)33 黄色
4)34 蓝色
5)35 紫色
6)36 青色
7)随机颜色
8)退出
EOF
echo -e '\E[0m'

read -p "请输入颜色编号(1-8)" NUM
case $NUM in
1)
	echo "PS1='\[\e[1;31m\][\u@\h \W]\\$ \[\e[0m\]'" > /etc/profile.d/env.sh
	$TIPS
	;;
2)
	echo "PS1='\[\e[1;32m\][\u@\h \W]\\$ \[\e[0m\]'" > /etc/profile.d/env.sh
	$TIPS
	;;
3)
	echo "PS1='\[\e[1;33m\][\u@\h \W]\\$ \[\e[0m\]'" > /etc/profile.d/env.sh
	$TIPS  
	;;
4)
	echo "PS1='\[\e[1;34m\][\u@\h \W]\\$ \[\e[0m\]'" > /etc/profile.d/env.sh
	$TIPS
	;;
5)
	echo "PS1='\[\e[1;35m\][\u@\h \W]\\$ \[\e[0m\]'" > /etc/profile.d/env.sh
	$TIPS
	;;
6)
	echo "PS1='\[\e[1;36m\][\u@\h \W]\\$ \[\e[0m\]'" > /etc/profile.d/env.sh
	$TIPS
	;;
7)
	echo "PS1='\[\e[1;"$[RANDOM%7+31]"m\][\u@\h \W]\\$ \[\e[0m\]'" > /etc/profile.d/env.sh
	$TIPS
	;;
8)
	break
	;;
*)
	echo -e "\e[1;31m输入错误,请输入正确的数字(1-8)!\e[0m"
	;;
esac	
done
}

PS3="请选择相应的编号(1-15,按enter键可显示菜单):"
MENU=" 
CentOS优化SSH
CentOS禁用SELinux
CentOS设置系统别名
CentOS设置vimrc配置文件
CentOS设置mailrc配置文件
CentOS设置YUM源
CentOS_Minimal安装建议安装软件
CentOS1-7全执行
CentOS7和8关闭Firewall防火墙 
CentOS更改SSH端口号
CentOS修改网卡名和IP地址
CentOS设置主机名
CentOS设置PS1(请进入选择颜色)
重启系统
退出
"

select menu in $MENU;do
case $REPLY in
1)
	optimization_sshd
	;;
2)
	disable_selinux
	;;
3)
	set_alias
	;;
4)
	set_vimrc
	;;
5)
	set_mailrc
	;;
6)
	set_yum
	;;
7)
	centos_minimal_install
	;;
8)
	optimization_sshd
	disable_selinux
	set_alias
	set_vimrc
	set_mailrc
	set_yum
	centos_minimal_install
	;;
9)
	disable_firewalld
	;;
10)
	set_sshd_port
	;;
11)
	set_eth_ip
	;;
12)
	set_hostname
	;;
13)
	set_centosps1
	;;
14)
	reboot
	;;
15)
	break
	;;
*)
	echo -e "\e[1;31m输入错误,请输入正确的数字(1-15)!\e[0m"
	;;
esac
done
