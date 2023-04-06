# Docker container for pBoca (Marathon of Parallel Programming)

Versão Inicial: João Vicente Lima <br>
Versão atualizada: Maurício Aronne PILLON <br>
Última Modificação: 23/03/2023 <br>
Distributor ID: Ubuntu <br>
Description:    Ubuntu 18.04.6 LTS <br>
Release:        18.04 <br>
Codename:       bionic <br>
PHP 5.6.40-65+ubuntu18.04.1+deb.sury.org+1 (cli) <br>
    <p>Copyright (c) 1997-2016 The PHP Group <br>
     Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies <br>
     with Zend OPcache v7.0.6-dev, Copyright (c) 1999-2016, by Zend Technologies <br>
<br>
URL: http://lspd.mackenzie.br/marathon/current/index.html <br>
GIT original (João V. Lima): https://github.com/joao-lima/boca.git <br>


## Clonagem dos arquivos de instalação docker pBoca
git clone https://github.com/mauriciopillon/pboca-docker-bionic <br>
cd pboca-docker-bionic/ <br>
## Lançar um terminal virtual
screen <br>
## Lançar docker pBoca
sudo docker-compose up --build <br>
## Detach terminal virtual
Cltr a+d <br>

## Versão atual lança o pBoca na porta 443
navegador: http://IP:PORTA/boca/ <br>
login: system <br>
passwd: boca <br>
<br>
* criar contest <br>
* habilitar contest <br>
* logar como admin <br>
* senha boca <br>
* criar usuários e alterar senha do admin<br>

## Cliente autojudge scripts de instalação
Versão Inicial: Calebe de Paula Bianchini <br>
Versão atualizada: Maurício Aronne PILLON <br>
Última Modificação: 23/03/2023 <br>

cd autojudge-install<br>
bash install-autojudge-BOCA.sh <br>

