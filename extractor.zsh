#!/usr/bin/env zsh
# 
# azet @ Mon Apr 23 00:49:38 CEST 2012
# MIT LICENSE (http://www.opensource.org/licenses/MIT)
#
# usage info - see: default case
# forks coroutines for extraction, has (cheap) signal,
# exception and PID handling. depends: unrar(1)
#
# debug:
#set -x
throw() {
	echo "\nexception: $@ \nexiting."
	if [ -n "$pids" ]; then
		echo -n "killing as many coroutines as possible: "
		for p in $pids; do pkill $p; echo -n ¤; done ; echo "\n"
	fi
	local return=anon
	function { exit -1 }
}
trap 'throw caught signal.' 1 2 9 11 15
case $# in 
	2)
		dir_path=$1 ; dir_egrepcmd=$2
		dirs=(`find $dir_path -maxdepth 1 -type d | egrep -e $dir_egrepcmd`)
		while :; do
			if [ ! $extract ]; then echo -n "\nscanning: "; else; echo -n "\nextracting: "; fi 
			for dir i in $dirs; do
				if [ ! $extract ]; then
					cd $dir; if ! incomplete=anon; function { test `ls | egrep '(%|part)' | wc -l` -lt 1 || nack_dir+=($dir) }; then
						ack_dir+=($dir)	
					fi; echo -n '.'
				else
					(	echo "\nJOB - extract PID: $!" ; echo "JOB - extract DIR: $dir\n"
						if for i in `find $dir/ | egrep -e '(rar|r[0-99]|zip)'`; do; echo -n . && unrar -y x $i &> /dev/null; done; then
							echo "\nDONE - EXTRACTED: $dir to $dir_path\n" 
						fi
					) & pids+=($!)
					finished=1
				fi
			done 
			if [ ! $finished ]; then
				echo "\n\nCOMPLETE:   $#ack_dir[*]" ; echo "INCOMPLETE:  $#nack_dir[*]"
				if [ $#ack_dir[*] -eq 0 ]; then throw 'nothing to extract..'; fi
				echo "\n!!! extract subroutines will be spawned, this can cause system load !!!\n"
				echo -n "extract directories or abort? y/ANY: " ; read usr_input
				[ $usr_input = "y" ] || throw 'abort.' ; extract=1
				echo "\n_READ_:\n  this operation might spawn a lot of processes (=CPU usage).\n  Ctrl-C to abort.\n"
				echo "..will start in eight seconds.." ; sleep 8
				for val in $ack_dir[@]; do $dirs+=$val; done ; 
				continue
			else
				wait $pids[-1] ; sleep 5
				echo "\n    >>  operation complete.  <<\n"
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
		echo "    -  argv 2 = directory egrep, e.g. 'backup' m
		atches 'DIR00101011_backup'"
		echo " e.g.:  \`zsh extractor.zsh /media/AES '(docs|cvs)'\`\n\n"
		exit -1
	;;
esac
#EOF
