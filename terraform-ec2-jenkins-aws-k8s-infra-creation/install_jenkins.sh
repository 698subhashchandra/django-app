#!/bin/bash

# Install Updated packages on linux machine
sudo yum update -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install jenkins -y
sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=8081"/' /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Java 17 (Commenting out other versions)
sudo dnf install java-17-amazon-corretto-devel -y

# Install Git
sudo yum install git -y

# Install Node.js and npm
sudo yum install nodejs npm -y

# Install Apache Maven
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum install unzip -y
sudo unzip awscliv2.zip
sudo ./aws/install

# Install ZAP Proxy
sudo wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2_14_0_unix.sh
sudo chmod +x ZAP_2_14_0_unix.sh
sudo ./ZAP_2_14_0_unix.sh -q

# Install kubectl
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
sudo cp kubectl /usr/local/bin/

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Install Docker
sudo yum install docker -y
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins
sudo newgrp docker
sudo systemctl start docker
sudo systemctl enable docker

# Install jq
sudo yum install jq -y

# Install Python 3 and pip
sudo yum install python3 -y
sudo yum install python3-pip -y

# Restart Jenkins to apply any changes
sudo systemctl restart jenkins

# Check status of services
sudo systemctl status jenkins
sudo systemctl status docker
