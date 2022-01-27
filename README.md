[![Docker](https://github.com/ibm-xaas/dev-env/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/ibm-xaas/dev-env/actions/workflows/docker-publish.yml)

# dev-env
##
tested in Ubuntu 18.04 and macOS Big Sur

## PREP

Please install the items below:
* docker
* docker-compose

## Available Tools
* terraform latest and tfenv
* terragrunt latest and tgenv
* packer latest and pkenv
* python 3.9 or later and pyenv
* ansible latest
* docker or docker-ce and docker-compose
* ibmcloud cli latest
* qemu and qemu-tools
* golang 1.17 or later

```
ubuntu@ubuntu-jenkins:/voljenkins/test/github/dev-env$ docker-compose run dev-env
ubuntu@57e2d9ce6b3a:/dev-env$
ubuntu@0519f2c1c374:/dev-env$ k version
Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.7", GitCommit:"1f86634ff08f37e54e8bfcd86bc90b61c98f84d4", GitTreeState:"clean", BuildDate:"2021-11-17T14:41:19Z", GoVersion:"go1.16.10", Compiler:"gc", Platform:"linux/amd64"}
The connection to the server localhost:8080 was refused - did you specify the right host or port?
ubuntu@0519f2c1c374:/dev-env$ helm version
version.BuildInfo{Version:"v3.7.2", GitCommit:"663a896f4a815053445eec4153677ddc24a0a361", GitTreeState:"clean", GoVersion:"go1.16.10"}
ubuntu@0519f2c1c374:/dev-env$ terraform version
Terraform v1.1.4
on linux_amd64
ubuntu@0519f2c1c374:/dev-env$ packer version
Packer v1.7.9
ubuntu@0519f2c1c374:/dev-env$ terragrunt -v
[INFO] Getting version from tgenv-version-name
[INFO] TGENV_VERSION is 0.35.20
terragrunt version v0.35.20
ubuntu@0519f2c1c374:/dev-env$ python -V
Python 3.9.10
ubuntu@0519f2c1c374:/dev-env$ ansible --version
ansible [core 2.12.1]
  config file = None
  configured module search path = ['/home/ubuntu/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/ubuntu/.pyenv/versions/3.9.10/lib/python3.9/site-packages/ansible
  ansible collection location = /home/ubuntu/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/ubuntu/.pyenv/versions/3.9.10/bin/ansible
  python version = 3.9.10 (main, Jan 19 2022, 19:20:03) [GCC 9.3.0]
  jinja version = 3.0.3
  libyaml = True
ubuntu@0519f2c1c374:/dev-env$ ic --version
ibmcloud version 2.3.0+26fbf88-2021-12-09T17:14:46+00:00
ubuntu@57e2d9ce6b3a:/dev-env$ qemu-img -V
qemu-img version 4.2.1 (Debian 1:4.2-3ubuntu6.19)
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
ubuntu@57e2d9ce6b3a:/dev-env$
```
