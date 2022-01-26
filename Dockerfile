FROM ubuntu:20.04

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME && \
	useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME

LABEL "maintainer"="SeungYeop Yang"
ENV WORKDIR=/dev-env

ENV DEBIAN_FRONTEND noninteractive
ENV TZ America/Central
RUN set -ex && \
	apt-get update && \
	apt-get install -y \
	tzdata \
	git \
	mercurial \
	build-essential \
	libssl-dev \
	libbz2-dev \
	zlib1g-dev \
	libffi-dev \
	libreadline-dev \
	libsqlite3-dev \
	curl \
	wget \
	jq \
	vim \
	unzip \
	iputils-ping \
	dnsutils \
	qemu-utils \
	qemu \
	qemu-system-x86 \
	cloud-image-utils \
	graphviz \
	sudo && \
	apt-get upgrade -y \
	e2fsprogs \
	libgcrypt20 \
	libgnutls30 && \
	apt autoremove -y && \
	apt clean -y && \
	rm -rf /var/lib/apt/lists/* && \
	echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
	chmod 0440 /etc/sudoers.d/$USERNAME

# set environmental variables
USER $USERNAME
ENV HOME "/home/${USERNAME}"
ENV LC_ALL "C.UTF-8"
ENV LANG "en_US.UTF-8"

# # golang 1.17.6
RUN set -ex && \
	cd ${HOME} && \
	wget -q https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz && \
	sudo tar -C /usr/local -xvzf go1.17.6.linux-amd64.tar.gz && \
	rm go1.17.6.linux-amd64.tar.gz && \
	mkdir -p ${HOME}/go && \
	sudo chown ${USER_UID}:${USER_GID} ${HOME}/go && \
	echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc
ENV PATH=/usr/local/go/bin:$PATH

# tfenv
RUN set -ex && \
	git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
	echo 'export PATH=$HOME/.tfenv/bin:$PATH' >> ~/.bashrc
ENV PATH=${HOME}/.tfenv/bin:$PATH
# tgenv
RUN set -ex && \
	git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv && \
	echo 'export PATH=$HOME/.tgenv/bin:$PATH' >> ~/.bashrc
ENV PATH=${HOME}/.tgenv/bin:$PATH
# pkenv
RUN set -ex && \
	git clone https://github.com/iamhsa/pkenv.git ~/.pkenv && \
	echo 'export PATH=$HOME/.pkenv/bin:$PATH' >> ~/.bashrc
ENV PATH=${HOME}/.pkenv/bin:$PATH

RUN set -ex && \
	cd ${HOME} && \
	tfenv install latest && \
	tgenv install latest && \
	pkenv install latest && \
	tfenv use latest && \
	tgenv use latest && \
	pkenv use latest

# ibmcloud cli client
# ibmcloud cli client installs docker
RUN set -ex && \
	cd ${HOME} && \
	sudo curl -sL https://ibm.biz/idt-installer | bash && \
	sudo ibmcloud plugin install vpc-infrastructure -f && \
	sudo ibmcloud plugin install cloud-object-storage -f && \
	sudo ibmcloud plugin install key-protect && \
	sudo ibmcloud plugin install tke && \
	sudo ibmcloud plugin install container-service && \
	sudo ibmcloud plugin install container-registry && \
	# docker-compose 1.25.5
	sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
	sudo chmod +x /usr/local/bin/docker-compose

# pyenv
ENV PYENV_ROOT "${HOME}/.pyenv"
ENV PATH "${HOME}/.pyenv/shims:${HOME}/.pyenv/bin:${PATH}"
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
#
# COPY requirements.txt ${HOME}/requirements.txt
#
RUN set -ex && \
	curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash && \
	pyenv install 3.9.10 && \
	pyenv global 3.9.10 && \
	pip install --upgrade pip && \
	# Ansible
	pip install ansible
# pip install -r ${HOME}/requirements.txt && \
# rm ${HOME}/requirements.txt && \

# install kubectl & helm v3
# kubectl was already installed probably from idt ks plugin
RUN set -ex && \
	curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN echo 'alias k="kubectl"' >> ~/.bashrc

RUN set -ex && \
	sudo curl -L https://github.com/aelsabbahy/goss/releases/latest/download/goss-linux-amd64 -o /usr/local/bin/goss && \
	sudo chmod +rx /usr/local/bin/goss && \
	cd ${HOME} && \
	mkdir -p ${HOME}/.packer.d/plugins && \
	cd ${HOME}/.packer.d/plugins && \
	wget -q https://github.com/YaleUniversity/packer-provisioner-goss/releases/download/v3.1.2/packer-provisioner-goss-v3.1.2-linux-amd64.zip && \
	unzip packer-provisioner-goss-v3.1.2-linux-amd64.zip && \
	rm -f packer-provisioner-goss-v3.1.2-linux-amd64.zip

# git@github.com:ibm-xaas/packer-provisioner-comment.git

RUN set -ex && \
	cd ${HOME} && \
	git clone https://github.com/ibm-xaas/packer-provisioner-comment.git && \
	cd packer-provisioner-comment && \
	#go mod init main && \
	go build && \
	mv main ${HOME}/.packer.d/plugins/packer-plugin-comment

WORKDIR $WORKDIR
