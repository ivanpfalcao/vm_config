ubuntu_install() {
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
    #apt install -y python-sphinx
    apt install -y python3-venv
    apt install -y terminator

    # Maven
    apt install -y maven


    # Editores
    apt install -y gedit
    apt install -y vim

    # Browsers
    # apt install -y chromium-browser

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

install_jmeter() {
    TMP_DIR="/tmp"
    JMETER_FILE="apache-jmeter-5.4.3.tgz"
    JMETER_FILE_PATH="${TMP_DIR}/${JMETER_FILE}"
    JMETER_HOME="/opt/apache-jmeter"

    if [ -f "${JMETER_FILE_PATH}" ]; then
        echo "${JMETER_FILE_PATH} exist. Not Downloading it"
    else 
        wget -O ${JMETER_FILE_PATH} https://dlcdn.apache.org/jmeter/binaries/${JMETER_FILE}
    fi

    rm -rf "${JMETER_HOME}"
    mkdir -p "${JMETER_HOME}"
    tar -xvf "${JMETER_FILE_PATH}" -C "${JMETER_HOME}" --strip-components=1
    chmod 775 -R "${JMETER_HOME}"

    PATH_SUB_FILE="/etc/bash.bashrc"

    sed -i "s+export JMETER_HOME=${JMETER_HOME}++g" "${PATH_SUB_FILE}"
    sed -i 's+export PATH=${JMETER_HOME}/bin:${PATH}++g' "${PATH_SUB_FILE}"
    echo "export JMETER_HOME=${JMETER_HOME}" >> "${PATH_SUB_FILE}"
    echo 'export PATH=${JMETER_HOME}/bin:${PATH}' >> "${PATH_SUB_FILE}"
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
    
    #MINICONDA_FILE="Miniconda3-py39_4.12.0-Linux-x86_64.sh"
    MINICONDA_FILE="Miniconda3-latest-Linux-x86_64.sh"
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
     
    # Noronha Things
    ${PIP_HOME}/pip install sphinx_rtd_theme

    # Spylon and jupyter
    ${PIP_HOME}/pip install jupyterlab
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
    SPARK_VERSION="3.5.1"
    SPARK_HADOOP_VERSION="-bin-hadoop3"
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

wsl_docker()
{
    echo "Starting installing docker"
    apt update && sudo apt upgrade
    apt remove docker docker-engine docker.io containerd runc
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release   

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null  

        echo "Docker successfully installed"

    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    usermod -aG docker "$EXEC_USER"
    echo 1 | update-alternatives --config iptables
}

install_k3d()
{
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
}


install_minikube()
{
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
    dpkg -i minikube_latest_amd64.deb
    minikube start
}

install_kubectl()
{
    #apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
    #curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    #echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    #apt-get update
    #apt-get install -y kubectl
    #echo "source <(kubectl completion bash)" >> /etc/bash.bashrc
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl    
}

install_vim()
{
    git clone https://github.com/vim/vim.git
    cd vim/src
    make
    sudo make install
}

install_groot()
{
    echo '' > /etc/sudo_lecture.txt
    echo '     [00;32m  \^V//' >> /etc/sudo_lecture.txt
    echo '     [00;33m  |[01;37m. [01;37m.[00;33m|   [01;34m I AM (G)ROOT!' >> /etc/sudo_lecture.txt
    echo '     [00;32m- [00;33m\ - / [00;32m_' >> /etc/sudo_lecture.txt
    echo '     [00;33m \_| |_/' >> /etc/sudo_lecture.txt
    echo '     [00;33m   \ \' >> /etc/sudo_lecture.txt
    echo '     [00;31m __[00;33m/[00;31m_[00;33m/[00;31m__' >> /etc/sudo_lecture.txt
    echo '     [00;31m|_______|  [00;37m With great power comes great responsibility.' >> /etc/sudo_lecture.txt
    echo '     [00;31m \     /   [00;37m Use sudo wisely.' >> /etc/sudo_lecture.txt
    echo '     [00;31m  \___/' >> /etc/sudo_lecture.txt
    echo '[0m' >> /etc/sudo_lecture.txt
    sed -i 's+Defaults       lecture=always++g' /etc/sudoers
    sed -i 's+Defaults       lecture_file=/etc/sudo_lecture.txt++g' /etc/sudoers
    echo "Defaults       lecture=always" >> /etc/sudoers
    echo "Defaults       lecture_file=/etc/sudo_lecture.txt" >> /etc/sudoers
}

install_istio()
{   
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.16.1 TARGET_ARCH=x86_64 sh -
    mv istio-1.16.1 /opt/istio-1.16.1
    chmod 775 -R /opt/istio-1.16.1
    PATH_SUB_FILE="/etc/bash.bashrc"
    echo "export PATH=${PATH}:/opt/istio-1.16.1/bin" >> ${PATH_SUB_FILE}    
}

install_helm()
{   
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh   
}

install_groot
# apt purge pidgin libreoffice-* gnome-mines gnome-sudoku parole thunderbird* xfburn
ubuntu_install
set_exec_user
# install_vscodium
#install_vscode
#install_scala
#install_spark
#install_jmeter
# install_postman
#install_dbeaver
install_miniconda
#install_python_things
#install_docker
wsl_docker
install_k3d
install_helm
#install_istio
install_minikube
install_kubectl
#configure_docker






