#!/bin/bash
homejail=/home/bocajail
[ "$1" != "" ] && homejail=$1
echo "================================================================================="
echo "============= CREATING $homejail (this might take some time) ==============="
echo "================================================================================="
for i in setquota ln id chown chmod dirname useradd mkdir cp rm mv apt-get dpkg uname debootstrap schroot; do
  p=`which $i`
  if [ -x "$p" ]; then
    echo -n ""
  else
    echo command "$i" not found
    exit 1
  fi
done
if [ "`id -u`" != "0" ]; then
  echo "Must be run as root"
  exit 1
fi
if [ ! -r /etc/lsb-release ]; then
  echo "File /etc/lsb-release not found. Is this a ubuntu or debian-like distro?"
  echo "If so, execute the command"
  echo ""
  echo "DISTRIB_CODENAME=WXYZ > /etc/lsb-release"
  echo ""
  echo "to save the release name to that file (replace WXYZ with your distro codename)"
  exit 1
fi
. /etc/lsb-release
if [ -d /bocajail/ ]; then
  echo "You seem to have already a /bocajail installed"
  echo "If you want to reinstall, remove it first (e.g. rm /bocajail) and then run /etc/icpc/createbocajail.sh"
  exit 1
fi

if [ -f $homejail/proc/cpuinfo ]; then
  echo "You seem to have already installed /bocajail and the /bocajail/proc seems to be mounted"
  chroot $homejail umount /sys >/dev/nul 2>/dev/null
  chroot $homejail umount /proc >/dev/nul 2>/dev/null
  echo "Please reboot the system to remove such mounted point"
  exit 1
fi

id -u bocajail >/dev/null 2>/dev/null
if [ $? != 0 ]; then
 useradd -m -s /bin/bash -d $homejail -g users bocajail
 if [ -d /etc/gdm ]; then
   echo -e "[greeter]\nExclude=bocajail,nobody\n" >> /etc/gdm/custom.conf
 fi
 sleep 1
else
  echo "user bocajail already exists"
  echo "if you want to proceed, first remove it (e.g. userdel bocajail) and then run /etc/icpc/createbocajail.sh"
  exit 1
fi
setquota -u bocajail 0 500000 0 10000 -a

rm -rf /bocajail
mkdir -p $homejail/tmp
chmod 1777 $homejail/tmp
ln -s $homejail /bocajail
#for i in usr lib var bin sbin etc dev; do
#  [ -d $homejail/$i ] && rm -rf $homejail/$i
#  cp -ar /$i $homejail
#done
#rm -rf $homejail/var/lib/postgres*
#rm -rf $homejail/var/www/*
#mkdir -p $homejail/proc
#mkdir -p $homejail/sys
uname -m | grep -q 64
if [ $? == 0 ]; then
  archt=amd64
else
  archt=i386
fi

cat <<FIM > /etc/schroot/chroot.d/bocajail.conf
[bocajail]
description=Jail
location=$homejail
directory=$homejail
root-users=root
type=directory
users=bocajail,nobody,root
FIM

#debootstrap --arch $archt $DISTRIB_CODENAME $homejail
debootstrap $DISTRIB_CODENAME $homejail
if [ $? != 0 ]; then
  echo "bocajail failed to debootstrap"
  exit 1
else
schroot -l | grep -q bocajail
if [ $? == 0 ]; then
  echo "bocajail successfully installed at $homejail"
else
  echo "*** some error has caused bocajail not to install properly -- I will try it again with different parameters"
  grep -v "^location" /etc/schroot/chroot.d/bocajail.conf > /tmp/.boca.tmp
  mv /tmp/.boca.tmp /etc/schroot/chroot.d/bocajail.conf
  debootstrap $DISTRIB_CODENAME $homejail
  schroot -l | grep -q bocajail
  if [ $? == 0 ]; then
    echo "*** bocajail successfully installed at $homejail"
  else
    echo "*** bocajail failed to install"
    exit 1
  fi
fi
fi

echo "*** Populating $homejail"
cat <<EOF > /home/bocajail/tmp/populate.sh
#!/bin/bash
mount -t proc proc /proc
apt-get -y update
apt-get -y install python-software-properties
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get -y update
apt-get -y upgrade
apt-get -y install g++ gcc libstdc++6 sharutils default-jdk default-jre
apt-get -y install gcc-4.8 g++-4.8
apt-get -y install openjdk-7-jdk openjdk-7-jre
apt-get -y clean

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6

update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-6-openjdk-*/jre/bin/java 10 
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-6-openjdk-*/bin/javac 10 
update-alternatives --install /usr/bin/javadoc javadoc /usr/lib/jvm/java-6-openjdk-*/bin/javadoc 10 
update-alternatives --install /usr/bin/javap javap /usr/lib/jvm/java-6-openjdk-*/bin/javap 10 
update-alternatives --install /usr/bin/javah javah /usr/lib/jvm/java-6-openjdk-*/bin/javah 10 

umount /proc
EOF
mkdir -p /bocajail/usr/bin
[ -x /usr/bin/safeexec ] && cp -a /usr/bin/safeexec /bocajail/usr/bin/
cp -f /etc/apt/sources.list $homejail/etc/apt/
chmod 755 /home/bocajail/tmp/populate.sh
cd / ; chroot $homejail /tmp/populate.sh
