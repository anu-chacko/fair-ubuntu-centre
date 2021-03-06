#!/bin/bash

echo "---------------------------------------"
echo "Installing apache2 http server         "
echo "---------------------------------------"

apt-get install -y -q apache2

# Modules for apache
apt-get install -y -q libapache2-mod-wsgi

echo "---------------------------------------"
echo "Setting up local web server"
echo "---------------------------------------"

# Note: Creating the link to the Ubuntu directory is done in repository.sh as well

# PDO: Don't know why the script at one time terminated here?
# echo "stop and die"
# exit

if [ ! -L /var/www/html/ubuntu ]
then
	echo "Creating links for our repository"
	ln -s ${FAIR_DRIVE_MOUNTPOINT}/ubuntu /var/www/html/ubuntu
	ln -s /var/www/html/ubuntu/pool /var/www/html/pool
fi

if [ ! -f /var/www/html/ubuntu/ubuntu ] && [ ! -d /var/www/html/ubuntu/ubuntu ] 
then
	ln -s /var/www/html/ubuntu/ /var/www/html/ubuntu/ubuntu
fi

echo "Copying Kickstart configuration file"
# These files automate the Ubuntu installation process by selecting which packages to install, and by running our custom 'post-install' script. 
cp ${FAIR_INSTALL_DATA}/ks*.cfg /var/www/html/

echo "Installing default index.html"
cp ${FAIR_INSTALL_DATA}/index.html /var/www/html

echo "Creating virtual hosts for the repository and the intranet..."
# PDO: We have several sub-domains on the server because it helps us ....??
cat ${FAIR_INSTALL_DATA}/etc.apache2.sites-available.000-default.conf > /etc/apache2/sites-available/000-default.conf
cat ${FAIR_INSTALL_DATA}/etc.apache2.sites-available.repo.conf > /etc/apache2/sites-available/repo.conf
cat ${FAIR_INSTALL_DATA}/etc.apache2.sites-available.intranet.conf > /etc/apache2/sites-available/intranet.conf
a2ensite repo
a2ensite intranet

service apache2 reload

echo "---------------------------------------"
echo "Camara"
echo "---------------------------------------"


if [ ! -d /var/www/html/camara ] && [ -d ${FAIR_DRIVE_MOUNTPOINT}/data/camara ]
then
        echo "Creating links for Camara"
	chmod -R o+r ${FAIR_DRIVE_MOUNTPOINT}/data/camara
	chmod -R o+X ${FAIR_DRIVE_MOUNTPOINT}/data/camara
        ln -s ${FAIR_DRIVE_MOUNTPOINT}/data/camara /var/www/html/camara
else
	echo "Camara directory already symlinked (or the directory does not exist in the FAIR archive)"
fi

echo "---------------------------------------"
echo "Distro folder (iso images of other linux)"
echo "---------------------------------------"


if [ ! -d /var/www/html/distros ] && [ -d ${FAIR_DRIVE_MOUNTPOINT}/data/distros ]
then
        echo "Creating links for linux distros"
	chmod -R o+r ${FAIR_DRIVE_MOUNTPOINT}/data/distros
	chmod -R o+X ${FAIR_DRIVE_MOUNTPOINT}/data/distros
        ln -s ${FAIR_DRIVE_MOUNTPOINT}/data/distros /var/www/html/distros
else
	echo "Linux distros directory already symlinked (or the directory does not exist in the FAIR archive)"
fi

