#!/bin/sh

# debconfs
sudo echo "ldap-auth-config        ldap-auth-config/bindpw password" | debconf-set-selections
sudo echo "ldap-auth-config        ldap-auth-config/rootbindpw     password" | debconf-set-selections
sudo echo "libpam-runtime  libpam-runtime/profiles multiselect     unix, ldap, systemd, capability" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/ldapns/ldap-server	string	ldap:///192.168.1.1" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/ldapns/base-dn	string	dc=csc,dc=wcupa,dc=edu" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/move-to-debconf	boolean	true" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/rootbinddn	string	cn=admin,dc=csc,dc=wcupa,dc=edu" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/dblogin	boolean	false" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/pam_password	select	md5" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/dbrootlogin	boolean	true" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/ldapns/ldap_version	select	3" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/binddn	string	cn=proxyuser,dc=example,dc=net" | debconf-set-selections
sudo echo "ldap-auth-config	ldap-auth-config/override	boolean	true" | debconf-set-selections
#sudo echo "libpam0g	libpam0g/restart-failed	error	" | debconf-set-selections
#sudo echo "libpam0g:amd64	libpam0g/restart-failed	error	" | debconf-set-selections
#sudo echo "libpam-runtime	libpam-runtime/conflicts	error	" | debconf-set-selections
#sudo echo "libpam0g	libpam0g/xdm-needs-restart	error	" | debconf-set-selections
#sudo echo "libpam0g:amd64	libpam0g/xdm-needs-restart	error	" | debconf-set-selections
#sudo echo "libpam0g	libraries/restart-without-asking	boolean	false" | debconf-set-selections
#sudo echo "libpam0g:amd64	libraries/restart-without-asking	boolean	false" | debconf-set-selections
#sudo echo "libpam0g	libpam0g/restart-services	string	" | debconf-set-selections
#sudo echo "libpam0g:amd64	libpam0g/restart-services	string	" | debconf-set-selections
#sudo echo "libpam-modules	libpam-modules/disable-screensaver	error	" | debconf-set-selections
#sudo echo "libpam-runtime	libpam-runtime/profiles	multiselect	unix, ldap, systemd, capability" | debconf-set-selections
#sudo echo "libpam-runtime	libpam-runtime/no_profiles_chosen	error" | debconf-set-selections
#sudo echo "libpam-runtime	libpam-runtime/override	boolean	false" | debconf-set-selections

sudo apt-get update
sudo apt-get install -y libnss-ldap libpam-ldap ldap-utils

sudo sed -i 's/compat systemd/compat systemd ldap/g' /etc/nsswitch.conf
sudo sed -i 's/use_authtok//g' /etc/pam.d/common-password
echo 'session optional pam_mkhomedir.so skel=/etc/skel umask=077' | sudo tee -a /etc/pam.d/common-session

sudo apt-get install -y nfs-common

#chkconfig nfs on
#service rpcbind start
#service nfs start

#mkdir /software
#mkdir /scratch
sleep 600
sudo mount 192.168.1.1:/home /home
sudo mount 192.168.1.1:/opt /opt
sudo mount 192.168.1.1:/software /software
sudo mount 192.168.1.1:/scratch /scratch
#mount -t nfs 192.168.1.1:/software /software
#mount -t nfs 192.168.1.2:/scratch /scratch

#while [ ! -d /software/flagdir ]
#do
#  sleep 30
#done

echo "export PATH='$PATH:/software/bin'" >> /users/jk880380/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/lib/'" >> /users/jk880380/.bashrc
source ~/.bashrc

#while [ ! -d /scratch/flagdir ]
#do
#  sleep 30
#done

echo "Done" >> /users/jk880380/clientdone.txt