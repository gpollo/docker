# Very Secure FTP Daemon

Simple and configurable docker image for running vsftpd.


## Environments variables

This image provides the following environments variables :

| Variables    | Description                                         | Default                   |
| ------------ | --------------------------------------------------- | ------------------------- |
| `FTP_USER`   | Defines the user that will run `vsftpd`.            | `vsftp`                   |
| `FTP_PASS`   | Defines the password of that user.                  | Randomly generated.       |
| `FTP_GROUP`  | Defines the ftp group that has access to the files. | `ftp`                     |
| `FTP_DIR`    | Defines the directory of the files.                 | `/srv/ftp`                |
| `FTP_CONFIG` | Defines the configuration files.                    | `/etc/vsftpd/vsftpd.conf` |
| `FTP_CONFIG` | Defines the configuration files.                    | `/etc/vsftpd/vsftpd.conf` |
| `FTP_PERM`   | Defines whether or not we should set permissions.   | `YES`                     |
