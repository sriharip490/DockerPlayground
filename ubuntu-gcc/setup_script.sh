#!/bin/bash

cmdflag=0
cmdstr="none"

exec_command()
{
   local_cmdstr=$1
   if [ $local_cmdstr == "build" ]; then
       ln -s /app/data .
       echo "Source folder link created"
   fi
}

while getopts "c:" opt; do
   case $opt in
      c)
         echo "Option -c was provided"
	 cmdflag=1
         cmdstr=$OPTARG
         ;;
      \?)
         echo "Invalid option: -$OPTARG" >&2
         exit 1
         ;;
      :)
         echo "Invalid option: -$OPTARG" >&2
         exit 1
         ;;
   esac
done


if [ $cmdflag -eq 1 ]; then
   exec_command $cmdstr
fi

