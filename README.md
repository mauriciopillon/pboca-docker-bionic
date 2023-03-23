# Docker container for ERAD-RS MPP 2023 Marathon

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


## Clonagem dos arquivos de instalação docker pBoca
git clone https://github.com/mauriciopillon/pboca-docker-bionic
cd pboca-docker-bionic/

## Lançar um terminal virtual
screen
## Lançar docker pBoca
sudo docker-compose up --build
## Detach terminal virtual
Cltr a+d

## Versão atual lança o pBoca na porta 443
# navegador: http://<IP>:<PORTA>/boca/
# login: system
# passwd: boca
#
#(*) criar contest
#(*) habilitar contest
#(*) logar como admin
#(*) senha boca

(*) criar usuários e alterar senha do admin

## Cliente autojugde scripts de instalação
################################################
### Versão Inicial: Calebe de Paula Bianchini
### Versão atualizada: Maurício Aronne PILLON
### Última Modificação: 23/03/2023
################################################
cd autojudge-install
cp -r autojudge-install /root  # (ou modifique o diretório de destino no script)
cd /root/autojudge-install
bash install-autojudge-BOCA.sh

