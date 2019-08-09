sudo apt update

sudo apt install -y dpkg
# Linguagens
sudo apt install -y build-essential
sudo apt install -y openjdk-8-jdk
sudo apt install -y python3-dev
sudo apt install -y python3-pip

# gedit
sudo apt install -y gedit

# Browsers
sudo apt install -y chromium-browser

# Scala
sudo apt install -y scala
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install -y sbt

# VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list
sudo apt update
sudo apt install codium

# Docker
sudo apt install -y docker
sudo apt install -y docker-compose

# Spark
cd /opt
sudo wget https://archive.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz
sudo tar -xvf spark-2.2.1-bin-hadoop2.7.tgz
sudo rm spark-2.2.1-bin-hadoop2.7.tgz
sudo chmod 777 -R spark-2.2.1-bin-hadoop2.7

# Zeppelin
cd /opt
sudo wget https://archive.apache.org/dist/zeppelin/zeppelin-0.8.1/zeppelin-0.8.1-bin-all.tgz
sudo mv zeppelin-0.8.1-bin-all.tgz /opt
cd /opt
sudo tar -xvf zeppelin-0.8.1-bin-all.tgz
rm zeppelin-0.8.1-bin-all.tgz
sudo chmod 777 -R zeppelin-0.8.1-bin-all

# POSTMAN
cd /opt
sudo wget https://dl.pstmn.io/download/latest/linux64
sudo tar -xvf linux64
sudo rm linux64
sudo chmod 777 -R Postman

#ROBO3t
cd /opt
sudo wget https://download-test.robomongo.org/linux/robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
sudo tar -xvf robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
sudo rm robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
sudo chmod 777 -R robo3t-1.3.1-linux-x86_64-7419c406