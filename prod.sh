#!/bin/sh

fusermount -u /tmp/ftp
mkdir -p /tmp/ftp

 curlftpfs gate.bonnetlive.net /tmp/ftp -o disable_epsv,user=lateb_billet:cscCeXJ@3
ls -l /tmp/ftp
rsync --update --times --recursive --stats --progress --perms --del --exclude=tmp/ --exclude=htdocs/ --exclude=nbproject/ --exclude=.git/ . /tmp/ftp/private
rsync --update --times --recursive --stats --progress --perms --del  ./htdocs /tmp/ftp/web
