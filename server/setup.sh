
apt-get -y update
apt-get -y upgrade

source ./configure_aliases
source ./configure_vim
source ./configure_git

apt-get -y install python3-pip
apt-get -y install unzip
apt-get -y install make
apt-get -y install cmake
apt-get -y install gnupg

cd /root
wget https://github.com/sickill/stderred/archive/refs/heads/master.zip
unzip master.zip
rm master.zip
cd stderred-master/
make
export LD_PRELOAD="/root/stderred-master/build/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
echo -e "export LD_PRELOAD=\"/root/stderred-master/build/libstderred.so\${LD_PRELOAD:+:\$LD_PRELOAD}\"" | tee -a ~/.bashrc
cd ~

apt install -y mysql-server
systemctl start mysql.service

echo "Copy the following command and paste into the mysql terminal to setup secure installation, set your own password"
echo "Exit the terminal after running command."
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';"
# sudo
mysql

echo "Follow prompts and finish secure installation"
mysql_secure_installation
echo "Insert password set in secure installation, then enter this command into the mysql terminal and exit"
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;"

mysql -u root -p

ufw app list
ufw allow OpenSSH
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 3306
ufw enable
ufw status

apt-get -y install nginx

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
apt-get update
apt-get install -y mongodb-org
systemctl start mongod

curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
apt-get update
apt-get -y install redis
