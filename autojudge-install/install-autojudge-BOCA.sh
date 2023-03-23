################################################
### Versão Inicial: Calebe de Paula Bianchini
### Versão atualizada: Maurício Aronne PILLON
### Última Modificação: 23/03/2023
################################################
#!/bin/bash -ex
MPP="autojudge-bin/"
PREFIX=$HOME"/"$MPP
CPATH=$CPATH:$PREFIX/include
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX/lib
PATH=$PATH:$PREFIX/bin
RED='\033[0;31m'
NC='\033[0m' # No Color
LOCAL=`pwd`

mkdir ../$MPP


echo "${RED}Installation at "$PREFIX
echo "Installing preirequisite packages ${NC}"
apt update
apt -y install zlib1g zlib1g-dev gcc g++ libxml2 libxml2-dev unzip

cd /tmp/
echo "${RED} Downloading and installing PostgreSQL-9.4.2 ${NC}"
wget -c -t0 -T10 "https://ftp.postgresql.org/pub/source/v9.4.2/postgresql-9.4.2.tar.bz2"
tar xjf postgresql-9.4.2.tar.bz2
cd postgresql-9.4.2
CC=gcc CXX=g++ ./configure --prefix=$PREFIX --without-readline
CC=gcc CXX=g++ make -j 10
CC=gcc CXX=g++ make install
cd ..

echo "${RED} If installed corretly, press Y to continue ${NC}"
read yes
if [ $yes != "Y" ] ; then
    echo "ERROR"
    exit 1;
fi

echo "${RED}Downloading and installing libmcrypt-2.5.8 ${NC}"
wget --max-redirect=500 -t0 -T10 "https://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmcrypt%2Ffiles%2FLibmcrypt%2F2.5.8%2Flibmcrypt-2.5.8.tar.gz%2Fdownload&ts=1569613168" -O libmcrypt-2.5.8.tar.gz
tar xzf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
CC=gcc CXX=g++ ./configure --prefix=$PREFIX --enable-static=yes
CC=gcc CXX=g++ make -j 10
CC=gcc CXX=g++ make install
cd ..

echo "${RED} If installed corretly, press Y to continue ${NC}"
read yes
if [ $yes != "Y" ] ; then
    echo "ERROR"
    exit 1;
fi

echo "${RED}Downloading and installing PHP-5.4.41${NC}"
wget -c -t0 -T10 "http://br2.php.net/get/php-5.4.41.tar.bz2/from/this/mirror" -O php-5.4.41.tar.bz2
#mv mirror php-5.4.41.tar.bz2
tar xjf php-5.4.41.tar.bz2
cd php-5.4.41
# CC=gcc CXX=g++ CFLAGS='-I/home/dasafio/MPP/include' CPP_FLAGS='-I/home/dasafio/MPP/include' ./configure --prefix=/home/desafio/MPP --with-pgsql=/home/desafio/MPP/ --enable-zip --with-mcrypt=/home/desafio/MPP/ --with-zlib
CC=gcc CXX=g++ ./configure --prefix=$PREFIX --with-pgsql=$PREFIX --enable-zip --with-mcrypt=$PREFIX --with-zlib
CC=gcc CXX=g++ make -j 10
CC=gcc CXX=g++ make install
cd ..

cp $LOCAL/bc-autojudge.sh $PREFIX/bin/.

echo "${RED}---------"
echo "*** Don't forget to update your PATH adding $PREFIX/bin, if necessary ***"
echo "export PATH=$PATH:" 
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" 
echo "---------${NC}"
