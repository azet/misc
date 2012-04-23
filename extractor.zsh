#!/bin/zsh
# 
# azet @ Mon Apr 23 00:49:38 CEST 2012
# MIT LICENSE (http://www.opensource.org/licenses/MIT)
#
# info - see: default case
# debug:
#set -x
throw() {
	echo "\nerror: $@ \n\nextractor.zsh: exiting."
	local return=anon
	function { exit -1 }
}
trap 'throw caught signal.' 1 2 9 11 15
case $# in 
	2)
		dir_path=$1 ; dir_egrepcmd=$2
		dirs=(`find $dir_path -maxdepth 1 -type d | egrep -e $dir_egrepcmd`) ; echo -n "scanning "
		while :; do
			for dir in $dirs; do
				if [ ! $extract ]; then
					cd $dir; if ! incomplete=anon; function { test `ls | egrep '(%|part)' | wc -l` -lt 1 || nack_dir+=($dir) }; then
						ack_dir+=($dir)	
					fi; echo -n '.'
				else
					(						
						echo "\nJOB - extract PID: $!" ; echo "JOB - extract DIR: $dir\n" 
						if for i in `find $dir/ | egrep -e '(rar|r[0-99]|zip)'`; do unrar -y x $i &> /dev/null; done; then
							echo "\nDONE - EXTRACTED: $dir\n" 
						fi
					) &
					wait
					finished=1
				fi
			done 
			if [ ! $finished ]; then
				echo "\n\nCOMPLETE:   $#ack_dir[*]" ; echo "INCOMPLETE:  $#nack_dir[*]"
				echo "\n!!! extract subroutines will be spawned, this can cause system load !!!\n"
				echo -n "extract directories or abort? y/ANY: " ; read usr_input
				[ $usr_input = "y" ] || throw 'abort.' ; extract=1 ; continue
			else
				echo "\noperation complete.\n"
				break
			fi
		done		
	;;
	*)
		echo "extractor.zsh:"
		echo " ~ extracts backups in .rar and .zip files and copies into a specified dir."
		echo " ~ uses regular expression patterns with egrep also checks if there is a file/dir"
		echo "   containing '%' or '.part'"
		echo
		echo " options:"
		echo "    -  argv 1 = working directory e.g. '/media/USBStick' (files will be copied here)"
		echo "    -  argv 2 = directory egrep, e.g. 'backup' matches 'DIR00101011_backup'"
		echo " e.g.:  \`zsh extractor.zsh /media/AES '(docs|cvs)'\`\n\n"
		exit -1
	;;
esac
#EOF