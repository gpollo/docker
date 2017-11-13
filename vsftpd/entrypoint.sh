#!/bin/sh

# default vsftpd group
if [ -z ${FTP_GROUP} ]; then
    FTP_GROUP=ftp
    echo "Configured group: ${FTP_GROUP}"
fi

# default vsftpd user
if [ -z ${FTP_USER} ]; then
    FTP_USER=vsftp
    echo "Configured user: ${FTP_USER}"
fi

# default vsftpd user password
if [ -z ${FTP_PASS} ]; then
    FTP_PASS=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-8};echo;)
    echo "Generated password: ${FTP_PASS}"
fi

# default files directory
if [ -z ${FTP_DIR} ]; then
    FTP_DIR=/srv/ftp
    echo "Configured ftp directory: ${FTP_DIR}"
fi

# default vsftpd config
if [ -z ${FTP_CONFIG} ]; then
    FTP_CONFIG=/etc/vsftpd/vsftpd.conf
    echo "Configuration file: ${FTP_CONFIG}"
fi

# add the group if it doesn't exist
GROUP=$(cat /etc/group | grep -i "^${FTP_GROUP}")
if [ -z ${GROUP} ]; then
    echo "Adding group ${FTP_GROUP}"
    addgroup -S ${FTP_GROUP}
fi

# add the user if he doesn't exist
id -u ${FTP_USER} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Adding user ${FTP_USER}"
    adduser -S ${FTP_USER}
fi

# add the user to the group if he isn't in
GROUP=$(groups ${FTP_USER} | grep -i "\b${FTP_GROUP}\b")
if [ -z ${GROUP} ]; then
    echo "Adding user ${FTP_USER} to group ${FTP_GROUP}"
    adduser ${FTP_USER} {$FTP_GROUP}
fi

# set ftp user password
echo "${FTP_USER}:${FTP_PASS}" | /usr/sbin/chpasswd

# we don't need to keep this
unset FTP_PASS

# create the files directory if it doesn't exist
mkdir -p ${FTP_DIR}

# set permissions on the ftp directory
if [ -z ${FTP_PERM} ]; then
    echo "Setting permissions in folder ${FTP_DIR}"
    chown -R ${FTP_USER}:${FTP_GROUP} ${FTP_DIR}
fi

# run the server
vsftpd ${FTP_CONFIG}
