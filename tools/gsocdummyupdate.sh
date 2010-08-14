#!/bin/bash

TARFILE=gsocdummy.tar.gz 
PORTFILE=$(port dir gsocdummy)/Portfile
read _ USER <<< $(id -p | grep login)
#make GSOCDUMMYDIR point to the directory containing "gsoc-dummy" tree
#GSOCDUMMYDIR=/Users/"$USER"/.macports/GSoC
GSOCDUMMYDIR=/opt/local/var/macports/sources/svn.macports.org/branches/gsoc10-configfiles/tools

cd "$GSOCDUMMYDIR" && \
tar zcf "$TARFILE" --exclude '*.svn*' gsocdummy && \
chown "$USER" "$TARFILE"

TMPFILE=/tmp/TempPortfile$(date +"%Y%m%d%H%M")
#let's just not be nice, we need an empty file
if [ -f "$TMPFILE" ]; then rm "$TMPFILE"; fi;
touch /tmp/tempPortfile

read _ md5Hash <<< $(openssl md5 "$TARFILE") 
read _ shaHash <<< $(openssl sha1 "$TARFILE")
read _ rmdHash <<< $(openssl rmd160 "$TARFILE")

md5="checksums           md5     $md5Hash \\"
sha="                    sha1    $shaHash \\"
rmd="                    rmd160  $rmdHash"

#   TODO: REPLACE ALL FOLLOWING PART WITH sed -i '' LINES
read num _ <<< $(wc -l "$PORTFILE")
head -n $((num-3)) "$PORTFILE" > "$TMPFILE"
printf "\n%s\n%s\n%s" "$md5" "$sha" "$rmd" >> "$TMPFILE"
printf "Portfile updated with:\n%s\n%s\n%s\n\n" "$md5" "$sha" "$rmd"

#update Portfile
cp "$TMPFILE" "$PORTFILE"
#update distfile, manual fetch phase
mkdir -p /opt/mp-gsoc/var/macports/distfiles/gsocdummy/
cp "$TARFILE" /opt/mp-gsoc/var/macports/distfiles/gsocdummy
#clean status
port clean gsocdummy
#clean /tmp too
rm "$TMPFILE"

