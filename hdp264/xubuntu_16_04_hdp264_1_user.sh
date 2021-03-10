BASEDIR="$( cd "$( dirname "${0}" )" && pwd )"

ubuntu_install() {
    apt update

    apt install -y dpkg
    apt install -y module-assistant
    apt install -y curl

    

    m-a prepare


    # Ambari dependencies
    apt install -y tar
    apt install -y sed
    apt install -y vim
    apt install -y maven
    apt install -y wget
    apt install -y postgresql
    apt install -y postgresql-contrib
    apt install -y openssh-server
    apt install -y ntp
    apt install -y libpostgresql-jdbc-java
    update-rc.d ntp defaults
    apt-get install -y gnupg2 
    service ssh start

    # Linguagens
    apt install -y build-essential
    apt install -y openjdk-8-jdk
    apt install -y python3-dev
    apt install -y python3-pip
    apt install -y python-sphinx
    apt install -y python3-venv

    # Maven
    apt install -y maven


    # Editores
    apt install -y gedit
    apt install -y vim

    # Browsers
    #apt install -y chromium-browser

    # Docker
    #apt install -y docker
    #apt install -y docker-compose

    # Notepad++
    # snap install notepad-plus-plus

    #Set showmode in vi
    echo "set showmode" >> ~/.vimrc

    PATH_SUB_FILE="/etc/bash.bashrc"
    echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> ${PATH_SUB_FILE}
    echo 'export JRE_HOME=${JAVA_HOME}/jre' >> ${PATH_SUB_FILE}
    echo 'export PATH=$PATH:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin' >> ${PATH_SUB_FILE}
    
    # Set terminal title
    echo 'set-title(){' >> ${PATH_SUB_FILE}
    echo '  ORIG=$PS1' >> ${PATH_SUB_FILE}
    echo '  TITLE="\e]2;$@\a"' >> ${PATH_SUB_FILE}
    echo '  PS1=${ORIG}${TITLE}' >> ${PATH_SUB_FILE}
    echo '}' >> ${PATH_SUB_FILE}
    
    # Debian version
    #apt-get install chromium chromium-l10n
}

# Get user ID
set_exec_user()
{
    echo "Start getting exec user"
    if [ "${SUDO_USER}" = "" ]; then
        EXEC_USER="${USER}"
    else
        EXEC_USER="${SUDO_USER}"
    fi
    echo "Configuring for user ${EXEC_USER}" 
}

install_miniconda()
{
    echo "Starting installing Miniconda"
    MINICONDA_HOME="/usr/share/miniconda"
    MINICONDA_GROUP="minicondagrp"
    CONDA_HOME="${MINICONDA_HOME}"
    CONDA_GROUP="${MINICONDA_GROUP}"    
    TMP_DIR="/tmp"
    
    MINICONDA_FILE="Miniconda3-py37_4.8.2-Linux-x86_64.sh"
    MINICONDA_FILE_PATH="${TMP_DIR}/${MINICONDA_FILE}"
    if [ -f "${MINICONDA_FILE_PATH}" ]; then
        echo "${MINICONDA_FILE_PATH} exist. Not Downloading it"
    else 
        wget -O ${MINICONDA_FILE_PATH} https://repo.anaconda.com/miniconda/${MINICONDA_FILE}
    fi
    sh ${MINICONDA_FILE_PATH} -u -b -p ${MINICONDA_HOME}
 
    # Anaconda Group
    groupadd ${CONDA_GROUP}
    chgrp -R ${CONDA_GROUP} ${MINICONDA_HOME}
    chmod 775 -R ${MINICONDA_HOME}

    PATH_SUB_FILE="/etc/bash.bashrc"
    sed -i "s+export MINICONDA_HOME=${MINICONDA_HOME}++g" ${PATH_SUB_FILE}
    sed -i 's+export PATH=${MINICONDA_HOME}/bin:${PATH}++g' ${PATH_SUB_FILE}  
    echo "export MINICONDA_HOME=${MINICONDA_HOME}" >> ${PATH_SUB_FILE}
    echo "export GIT_PYTHON_REFRESH=quiet" >> ${PATH_SUB_FILE}
    echo 'export PATH=${MINICONDA_HOME}/bin:${PATH}' >> ${PATH_SUB_FILE} 

    adduser ${EXEC_USER} ${CONDA_GROUP} || true
    usermod -a -G ${CONDA_GROUP} ${EXEC_USER}
    echo "Others. User ${EXEC_USER} added to ${CONDA_GROUP}"

    echo "Miniconda successfully installed"
}

install_python_things() {
    GENERAL_VENV="/home/${EXEC_USER}/general-venv"
    PIP_HOME="${GENERAL_VENV}/bin"

    rm -rf "${GENERAL_VENV}"
    ${CONDA_HOME}/bin/conda create --prefix="${GENERAL_VENV}" python="3.7" -y
    chgrp -R ${CONDA_GROUP} ${GENERAL_VENV}
    source ${CONDA_HOME}/bin/activate ${GENERAL_VENV}
     
    #Noronha Things
    ${PIP_HOME}/pip install sphinx_rtd_theme
    ${PIP_HOME}/pip install jupyter
    ${PIP_HOME}/pip install ipython
    ${PIP_HOME}/pip install spylon-kernel
    ${PIP_HOME}/python -m spylon_kernel install

    PATH_SUB_FILE="/etc/bash.bashrc"
    sed -i "s+export GENERAL_VENV=${GENERAL_VENV}++g" ${PATH_SUB_FILE}
    echo "export GENERAL_VENV=${GENERAL_VENV}" >> ${PATH_SUB_FILE}
}


install_scala() {
    # Scala
    wget https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.deb
    dpkg -i scala-2.12.2.deb
    rm scala-2.12.2.deb

    apt-get install -y sbt
}


install_vscodium() {
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | apt-key add -
    echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | tee --append /etc/apt/sources.list
    apt update
    apt install -y codium
}

install_vscode() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    apt-get install -y apt-transport-https
    apt-get update
    apt-get install -y code    
}





install_spark() {
    # Spark
    cd /opt
    SPARK_VERSION="2.2.0"
    SPARK_HADOOP_VERSION="-bin-hadoop2.7"
    wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}.tgz
    tar -xvf spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}.tgz
    rm spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}.tgz
    chmod 755 -R spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}

    PATH_SUB_FILE="/etc/bash.bashrc"
    sed -i "s+export SPARK_HOME=/opt/spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}++g" ${PATH_SUB_FILE}
    sed -i 's+export PATH=$PATH:$SPARK_HOME/bin++g' ${PATH_SUB_FILE}
    sed -i 's+export PYSPARK_PYTHON=/usr/bin/python3++g' ${PATH_SUB_FILE}
    echo "export SPARK_HOME=/opt/spark-${SPARK_VERSION}${SPARK_HADOOP_VERSION}" >> ${PATH_SUB_FILE}
    echo 'export PATH=$PATH:$SPARK_HOME/bin' >> ${PATH_SUB_FILE}
    echo 'export PYSPARK_PYTHON=/usr/bin/python3' >> ${PATH_SUB_FILE}
}


install_zeppelin() {
    # Zeppelin
    cd /opt
    ZEPPELIN_VERSION="0.8.2"
    wget https://archive.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz
    mv zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz /opt
    cd /opt
    tar -xvf zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz
    rm zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz
    chmod 755 -R zeppelin-${ZEPPELIN_VERSION}-bin-all
}

install_postman() {
    # POSTMAN
    cd /opt
    wget https://dl.pstmn.io/download/latest/linux64
    tar -xvf linux64
    rm linux64
    chmod 755 -R Postman
}

install_robo3t() {
    #ROBO3t
    cd /opt
    wget -O robo3t.tar.gz https://download-test.robomongo.org/linux/robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
    tar -xvf robo3t.tar.gz
    rm robo3t.tar.gz
    #chmod 755 -R robo3t-1.3.1-linux-x86_64-7419c406.tar.gz
}


install_dbeaver() {
    #Install DBeaver
    cd /tmp
    wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
    dpkg -i dbeaver-ce_latest_amd64.deb
    rm dbeaver-ce_latest_amd64.deb
}






configure_docker() {
    # groupadd docker
    usermod -aG docker ${EXEC_USER}
    newgrp docker

    # Start Docker Swarm
    docker swarm init
    exit

}

# Anaconda
#wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
#bash Anaconda3-2020.02-Linux-x86_64.sh -b -p $HOME/anaconda


install_microk8s() {
    # microk8s
    snap install microk8s --classic
    microk8s.enable dns dashboard registry
    alias microk8s.kubectl kubectl
}

install_docker()
{
    echo "Starting installing docker"
    DOCKER_INST_FILE=${TMP_DIR}/install_docker.sh
    if [ -f "${DOCKER_INST_FILE}" ]; then
        echo "${DOCKER_INST_FILE} exist. Not Downloading it"
    else 
        #curl -fsSL https://get.docker.com -o ${DOCKER_INST_FILE}
        wget -O ${DOCKER_INST_FILE} https://get.docker.com
    fi
    sh ${DOCKER_INST_FILE}

    case "$(echo "${OS_NAME}" | tr a-z A-Z)" in
        "CENTOS LINUX"|"CENTOS"|"REDHAT")
            systemctl start docker
            systemctl enable docker
            ;;
    esac    

    echo "Docker successfully installed"
}

install_minikube()
{
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
    dpkg -i minikube_latest_amd64.deb
    minikube start
}

install_kubectl()
{
    apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubectl
}


install_ambari()
{
    
    echo "Installing Ambari"
    AMBARI_USER="ambari"
    AMBARI_PASSWORD='ambari'
    AMBARI_DATABASE="ambari"
    AMBARI_SCHEMA="ambari"

    wget -O /etc/apt/sources.list.d/ambari.list http://public-repo-1.hortonworks.com/ambari/ubuntu18/2.x/updates/2.6.2.45/ambari.list
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD
    apt update
    apt install -y ambari-agent
    apt install -y ambari-server  
    echo "Ambari Installed"
    
}


configure_ssh() 
{
    AMBARI_USER="hdp"
    ssh-keygen -b 2048 -t rsa -f "/root/.ssh/id_rsa" -N ""

    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys

    ssh -oStrictHostKeyChecking=no 127.0.0.1 'exit'
    ssh -oStrictHostKeyChecking=no localhost 'exit'
    ssh -oStrictHostKeyChecking=no $(hostname -f) 'exit'
}

ambari_setup()
{
    echo 'export HDP_VERSION=\"2.6.4\"' >> "/etc/bash.bashrc"
    echo 'export HADOOP_HOME=\"/usr/hdp/2.6.0.3-8/hadoop\"' >> "/etc/bash.bashrc"
    echo 'export ZOOKEEPER_HOME=\"/usr/hdp/current/zookeeper-client\"' >> "/etc/bash.bashrc"
    echo 'export HCAT_HOME=\"/usr/hdp/current/\"' >> "/etc/bash.bashrc"
    echo 'export ACCUMULO_HOME=\"/usr/hdp/current/\"' >> "/etc/bash.bashrc"
    echo 'export HBASE_HOME=\"/usr/hdp/2.6.0.3-8/hbase\"' >> "/etc/bash.bashrc"

    ambari-server setup -j "${JAVA_HOME}" \
        -s \
        --database="postgres" \
        --databasehost=127.0.0.1 \
        --databaseport=5432 \
        --databasename="${AMBARI_DATABASE}" \
        --postgresschema="${AMBARI_SCHEMA}" \
        --databaseusername="${AMBARI_USER}" \
        --databasepassword="${AMBARI_PASSWORD}"

    ambari-server setup \
        --jdbc-db=postgres \
        --jdbc-driver=/usr/share/java/postgresql-jdbc4.jar
}

ambari_postgresql_config()
{
    cp ${BASEDIR}/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf
    service postgresql restart 
    sudo -u postgres psql --command "CREATE USER root WITH SUPERUSER PASSWORD '';" 
    sudo -u postgres psql --command "CREATE DATABASE ${AMBARI_DATABASE};" 
    sudo -u postgres psql --command "CREATE USER ${AMBARI_USER} WITH PASSWORD '${AMBARI_PASSWORD}';" 
    sudo -u postgres psql --command "GRANT ALL PRIVILEGES ON DATABASE ${AMBARI_DATABASE} TO ${AMBARI_USER};" 
    sudo -u postgres psql -d ${AMBARI_DATABASE} --command "CREATE SCHEMA ${AMBARI_SCHEMA} AUTHORIZATION ${AMBARI_USER};" 
    sudo -u postgres psql -d ${AMBARI_DATABASE} --command "ALTER SCHEMA ${AMBARI_SCHEMA} OWNER TO ${AMBARI_USER};" 
    sudo -u postgres psql -d ${AMBARI_DATABASE} --command "ALTER ROLE ${AMBARI_USER} SET search_path to '${AMBARI_SCHEMA}', 'public';"   
    export PGPASSWORD="${AMBARI_PASSWORD}"; psql -d ${AMBARI_DATABASE} -U ${AMBARI_USER} -f /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql 
    sudo -u postgres psql --command "CREATE DATABASE ${HIVE_DATABASE};" 
    sudo -u postgres psql --command "CREATE USER ${HIVE_USER} WITH PASSWORD '${HIVE_PASSWORD}';" 
    sudo -u postgres psql --command "GRANT ALL PRIVILEGES ON DATABASE ${HIVE_DATABASE} TO ${HIVE_USER};" 
    sudo -u postgres psql -d ${HIVE_DATABASE} --command "CREATE SCHEMA ${HIVE_SCHEMA} AUTHORIZATION ${HIVE_USER};" 
    sudo -u postgres psql -d ${HIVE_DATABASE} --command "ALTER SCHEMA ${HIVE_SCHEMA} OWNER TO ${HIVE_USER};" 
    sudo -u postgres psql -d ${HIVE_DATABASE} --command "ALTER ROLE ${HIVE_USER} SET search_path to '${HIVE_SCHEMA}', 'public';"

    
}


AMBARI_USER=ambari
AMBARI_PASSWORD='ambari'
AMBARI_DATABASE=ambari
AMBARI_SCHEMA=ambari

HIVE_USER=hive
HIVE_PASSWORD='hive'
HIVE_DATABASE=hive
HIVE_SCHEMA=hive



ubuntu_install
set_exec_user
install_vscode
# # install_scala
install_miniconda
install_python_things

#configure_ssh
#ambari_postgresql_config
#install_ambari

# hdfs -> config -> Advanced -> Custom core-site -> hadoop.proxyuser.hive.hosts=*
# hdfs dfsadmin -safemode leave
# beeline -n hdp -u "jdbc:hive2://127.0.0.1:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2"

