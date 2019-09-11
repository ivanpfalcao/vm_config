apt update

apt install -y dpkg
apt install -y module-assistant
m-a prepare

# Linguagens
apt install -y build-essential
apt install -y openjdk-8-jdk
apt install -y python3-dev
apt install -y python3-pip

# gedit
apt install -y gedit

# Browsers
apt install -y chromium-browser

# Debian version
#apt-get install chromium chromium-l10n

# Scala
apt install -y scala
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
apt-get update
apt-get install -y sbt

# Maven
apt install -y maven

# VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | apt-key add -
echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | tee --append /etc/apt/sources.list
apt update
apt install codium

# Docker
apt install -y docker
apt install -y docker-compose

# Spark
cd /opt
wget https://archive.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz
tar -xvf spark-2.2.1-bin-hadoop2.7.tgz
rm spark-2.2.1-bin-hadoop2.7.tgz
chmod 777 -R spark-2.2.1-bin-hadoop2.7

# Zeppelin
cd /opt
wget https://archive.apache.org/dist/zeppelin/zeppelin-0.8.1/zeppelin-0.8.1-bin-all.tgz
mv zeppelin-0.8.1-bin-all.tgz /opt
cd /opt
tar -xvf zeppelin-0.8.1-bin-all.tgz
rm zeppelin-0.8.1-bin-all.tgz
chmod 777 -R zeppelin-0.8.1-bin-all

# POSTMAN
cd /opt
wget https://dl.pstmn.io/download/latest/linux64
tar -xvf linux64
rm linux64
chmod 777 -R Postman

#ROBO3t
cd /opt
wget https://download-test.robomongo.org/linux/robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
tar -xvf robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
rm robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
chmod 777 -R robo3t-1.3.1-linux-x86_64-7419c406


cd /tmp
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
dpkg -i dbeaver-ce_latest_amd64.deb

