#!/bin/bash

#сhecking directory /tmp/backups

if ! [ -d /tmp/backups ]; then
mkdir /tmp/backups
fi

#cheking for the number of argumets

if [ "$#" -ne 2 ]; then
echo "Wrong numbers of arguments!" >&2;
exit;
fi

#cheking the first argument

if ! [ -d "$1" ]; then
echo "Incorrect first argument or there is no such directory!" >&2
exit;
fi

#cheking the second one

secondArg='^[0-9]+$'
if ! [[ $2 =~ $secondArg ]]; then
echo "Second Argument is not a number" >&2;
exit;
fi

#deleting old files

cd "$1"
tarname2=`pwd | sed 's/\//-/g' | cut -c 2-`
cd /tmp/backups
fa=`find . -type f -name "$tarname2*.tar.gz" | wc -l`
sh=`echo $(( $2 - 1 ))`
diff=`echo $(( $fa - $sh ))`
if [[ "$fa" -gt "$2" ]]; then
ls -1rt | grep "$tarname2" | head -"$diff" | xargs rm -f
fi

if [[ "$fa" -eq "$2" ]]; then
ls -1rt | grep "$tarname2" |  head -1 | xargs rm -f
fi

#tar.gz file creation and moving to the /tmp/backups

cd "$1"
dirName="${1}"
tarName=`{ pwd | sed -r 's/[/]+/-/g' | sed 's/^-//'; date '+%D/%H-%M-%S' | sed 's/\//-/g'; } | sed ':a;N;s/\n//;ba'`
files=`{ find . -type f | cut -c3-; find . -type d | cut -c3-; }`
tar cfz $tarName.tar.gz $files
mv "$tarName.tar.gz" "/tmp/backups"


