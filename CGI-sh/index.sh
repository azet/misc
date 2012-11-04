#!/bin/sh
#              -- a bourne shell cgi directory indexer --
#
# 
#    written by azet < azet@azet.org > - 08.02.2011 - [POST BLUE!]
#
#  <large parts of readme omitted>
# 
#  - this script only uses standard userland linux and unix programmes
#  and commands. it should be highly portable. if something doesn't
#  work on exotic platforms or operating systems, check the right paths 
#  to the binaries used in this script and modify them accordingly. 
#  _chroot note_: if your webserver runs in a chroot or e.g. jail, check 
#  the binaries used in this script as explained above and copy them to 
#  your chroot. /also/ don't forget to "ldd" the binaries and copy their 
#  belonging ldd-files. this will work.
#
#  - if you want to use a stylesheet, define it below and put it in the 
#  same folder as this script is stored in.
#
#  - you can restrict the view of the file system path on the index file
#  script with the 'restrict_fs_path' variable below. just set it to 0
#  if you want the full path shown.
#
#
# leave the following unchanged!
license="ISC License (ISCL)"
scriptname="yacgindex"
scriptversion="0.1.1a"
scriptbanner="&#62;&#62; ..yet another cgi directory tool"
#
#
##########################################################################
#                           CONFIGURATION                                #
##########################################################################
stylesheet=""                                                            #
restrict_fs_path="1"                                                     #
##########################################################################


#global vars.
filecount=`ls * | wc -l | awk '{ print $1 }'`
directory=`echo $PWD | sed 's/....\///g'`
directoryfull=`echo $PWD`

#function definitions:
set_content_type() {
	case "$QUERY_STRING" in 
		*) echo -e "Content-type: text/html\n" ;; #default to html
		"plain") echo -e "Content-type: text/plain\n" ;; #plain text output e.g. sourcecode
		"gif/jpeg") echo -e "Content-type: text/plain\n ..too come.." ;; #picture output - XXX:TODO
	esac
}

list_index() {
	list_cmd=`ls -Rf *` 
	if let 'restrict_fs_path == 0'; then $list_cmd
	elif let 'restrict_fs_path == 1'; then $list_cmd
	else
		echo -e "\n\t<div id=\"err_msg\"><strong>\n\tconfiguration error, check the script variables!\n\t<p>..exiting..</p>\n\t</strong></div>\n"
		exit
	fi	
	echo -e "<div id=\"index\">\n<label><strong>&#62;&#62; Directory - ...<a href=\"#\" class=\"dirurl\">$directory</a></strong></label>\n"
	echo -e "<dir>\n\n"     
	for list in $list_cmd ; do
        	echo -e "<span id=\"hide\"><dd><a href=\"/$list\">$list</a></dd></span>\n"  # .. index list to be printed out - edit XHTML here, if you want to.
	done
	echo -e "</dir>\n</div>\n"
}


#include custom stylesheet if variable contains valid value
if [ -n $stylesheet ]; then
	css_string=`echo -e "\n\t<link rel=\"stylesheet\" type=\"text/css\" href=\"$stylesheet\">\n"`
else
	css_string=""
fi


#decide content type and direct content:
case $QUERY_STRING in
	#everything thats not standard (x)html output comes first due to batch order:
	"code") #for code files
		set_content_type "html"
		echo -e "\t\n<pre>\n"
		ls
		echo -e "\t\n</pre>\n"
	;;
	"plain") #plaintext option
		set_content_type "plain" 
		echo -e "\n$scriptname $scriptversion @ $SERVER_NAME:\n"
		echo -e "\n\ndirectory listing of ...$directory ($filecount file/s):\n\n"
		for currentobject in `ls *`; do
			if [ -d $currentobject ]; then echo -e "---\n    o $currentobject\n"
			elif [ -f $currentobject]; then	echo "--> * $currentobject"
			fi
		done
		echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
		#plaintext index signature
		echo -e "Running daemon: $SERVER_SOFTWARE @ $SERVER_NAME on Port $SERVER_PORT via $GATEWAY_INTERFACE"
		echo -e "$scriptname   $scriptversion  (written in bourne shell)   $license   -   Open Source"
		
		exit
	;;
	*) set_content_type "html" ;; #default to (x)html
esac



#lets actually start with some xhtml output, shall we?..
cat << XHTML_EOT
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN"
	"http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<title>$0 script -- index of $directory</title>	
	<script src="http://code.jquery.com/jquery-1.4.4.js"></script>
	$css_string
	<style type="text/css">
	/* yacgindex example css template  *
	 * by azet - fast, cheap and dirty */

	body { 
		font-family: helvetica, impact, sans-serif; 
		font-size: 14px; 
		background-color: #413839;
		color: #C9C299;
		margin: 25px;
	}
	#header { 
		border-left: 4px solid #7E2217;
		padding-bottom: 5px; 
		text-indent: 10px; 
		font-size: 12px;
	}
	h1 { 
		font-size: 20px; 
		font-weight: bold;
		background-color: #667C26;
		border-left: 4px solid #7E2217;
		border-bottom: 1px solid #7E2217;
		word-spacing: 5px;
		letter-spacing: 5px;
		text-indent: 20px;
		padding: 5px;
		color: #7E2217;
		margin: 0px;
	}
	#banner { 
		text-align: right;
		padding-right: 10px;
		font-size: 14px;
		word-spacing: 35px;
		margin-bottom: 50px;	
		color: #667C26;
		border-right: 4px solid #667C26; 
		font-weight: lighter;
	}
	h2 { 
		font-size: 14px; 
		text-indent: 15px;
		letter-spacing: 5px; 
		border-bottom: 1px solid #667C26; 
		border-left: 4px solid #667C26; 
		padding-bottom: 5px;
		text-decoration: underline dashed;
		align: left;
		width: 65%;
		color: #667C26;
	}
	hr { 
		align: center;
		margin-top: 50px;
		border: 0px;
		border-top: 1px solid #667C26; 
		border-right: 4px solid #667C26; 
		border-left: 4px solid #667C26; 
		width: 85%; 
		height: 5px;
	}
	#index { 
		color: #7E2217;
		background-color: #667C26; 
		padding: 20px; 
		border-left: 4px solid #7E2217;
		border-bottom: 1px solid #7E2217;
		width: 65%;
		word-spacing: 5px;
	}
	#footer_left {
		float: left; 
		text-align: center;
		font-size: 10px;
	}
	#footer_right {
		float: right; 
		text-align: center;
		font-size: 10px;
	}

	#hide { display: none } /* jQuery example */

	address {
		letter-spacing: 2px;
		color: #667C26;
		font: small caps; 
	}
	a:link {color: #C9C299; text-decoration: none; }
	a:active {color: #C9C299; text-decoration: none; }
	a:visited {color: #C9C299; text-decoration: none; }
	a:hover {color: #C9C299; text-decoration: underline; }
	</style>
</head>
<body>
	<div id="header">
		&#62;&#62; [ $HTTP_REFERER ]
	</div>
	<h1>$scriptname $scriptversion @ $SERVER_NAME</h1>
	<div id="banner">$scriptbanner</div>
	<h2>index of ...$directory* ($filecount file/s):</h2>
	<span>
		(* full filesystem path info view is restricted!)
	</span>
	<div id="scriptlinks">
		<a href="?plain">display in plain text</a>
	</div>
XHTMLEOT

	# list index, if any problem occurs, throw meaningless error at user - this is main()
	if ( ! list_index ); then echo -e "<strong>major listing error - contact the system administrator</strong>"; fi
	
	
cat << XHTMLEOT
	<script type="text/javascript">
		$(".dirurl").click(function () {
			$("#hide").toggle("slow");
		});
	</script>
	<hr />
	<address>
		<span id="footer_left">running on daemon: $SERVER_SOFTWARE via $GATEWAY_INTERFACE @ $SERVER_NAME on port $SERVER_PORT</span>
		
		<!---- do not remove this, click it, read the source, understand and have fun with cgi :) ---->
		
		<span id="footer_right">
			this <a href="http://en.wikipedia.org/wiki/Bourne_shell">bourne shell</a> script is <span style="text-decoration: underline">open source</span>: 
			<a href="?code&about">$scriptname, $scriptversion</a><br/>
			is licsensed under the <a href="http://www.opensource.org/licenses/isc-license">$license</a>. and therefore permission is granted to<br /> 
			"use, copy, modify, and/or distribute thissoftware for any purpose with or without fee".
		</span>
	</address>
XHTML_EOT
#this is the end,.. my only friend.
