apt update

apt install -y dpkg
apt install -y module-assistant
apt install -y curl
m-a prepare

# Linguagens
apt install -y build-essential
apt install -y openjdk-8-jdk
apt install -y python3-dev
apt install -y python3-pip
apt install -y python-sphinx

# Editores
apt install -y gedit
apt install -y vim

# Browsers
apt install -y chromium-browser

# Debian version
#apt-get install chromium chromium-l10n

# Scala
#apt install -y scala
#echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
#apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
#apt-get update
wget https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.deb
dpkg -i scala-2.12.2.deb
rm scala-2.12.2.deb

apt-get install -y sbt

# Maven
apt install -y maven

# VSCodium
#wget https://github.com/VSCodium/vscodium/releases/download/1.38.1/codium_1.38.1-1568285248_amd64.deb
#dpkg -i codium_1.38.1-1568285248_amd64.deb
#rm codium_1.38.1-1568285248_amd64.deb
#wget https://github.com/VSCodium/vscodium/releases/download/1.40.0/codium_1.40.0-1573156533_amd64.deb
#dpkg -i codium_1.40.0-1573156533_amd64.deb
#rm codium_1.40.0-1573156533_amd64.deb
#wget https://github.com/VSCodium/vscodium/releases/download/1.40.2/codium_1.40.2-1574798581_amd64.deb
wget -O vscodium.deb https://github.com/VSCodium/vscodium/releases/download/1.42.1/codium_1.42.1-1581651960_amd64.deb
dpkg -i vscodium.deb
rm vscodium.deb

#wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | apt-key add -
#echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | tee --append /etc/apt/sources.list
#apt update
#apt install -y codium

# Docker
apt install -y docker
apt install -y docker-compose

# Spark
cd /opt
SPARK_VERSION="2.2.1"
SPARK_HADOOP_VERSION="-bin-hadoop2.7"
wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}.tgz
tar -xvf spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}.tgz
rm spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}.tgz
chmod 755 -R spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}


# Zeppelin
cd /opt
ZEPPELIN_VERSION="0.8.2"
wget https://archive.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz
mv zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz /opt
cd /opt
tar -xvf zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz
rm zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz
chmod 755 -R zeppelin-${ZEPPELIN_VERSION}-bin-all

# POSTMAN
cd /opt
wget https://dl.pstmn.io/download/latest/linux64
tar -xvf linux64
rm linux64
chmod 755 -R Postman

#ROBO3t
cd /opt
wget -O robo3t.tar.gz https://download-test.robomongo.org/linux/robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
tar -xvf robo3t.tar.gz
rm robo3t.tar.gz
#chmod 755 -R robo3t-1.3.1-linux-x86_64-7419c406.tar.gz

#Install DBeaver
cd /tmp
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
dpkg -i dbeaver-ce_latest_amd64.deb
rm dbeaver-ce_latest_amd64.deb

# Notepad++
snap install notepad-plus-plus

#Set showmode in vi
echo "set showmode" >> ~/.vimrc

#Noronha Theme
sudo pip3 install sphinx_rtd_theme

# Docker without sudo
groupadd docker
usermod -aG docker $USER

# Start Docker Swarm
docker swarm init

# Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
bash Anaconda3-2020.02-Linux-x86_64.sh -b -p $HOME/anaconda
