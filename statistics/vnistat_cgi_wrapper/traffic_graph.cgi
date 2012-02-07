#!/bin/sh
#
# azet 9.8.2011
#  
# BSD license (http://opensource.org/licenses/BSD-3-Clause)
#
#
# vars:

if_bge0=`/usr/local/bin/vnstati -vs -ne -i bge0 -o img/bge0.png`
if_bge0_m=`/usr/local/bin/vnstati -m -ne -i bge0 -o img/bge0_m.png`

if_bge1=`/usr/local/bin/vnstati -vs -ne -i bge1 -o img/bge1.png`
if_bge1_m=`/usr/local/bin/vnstati -m -ne -i bge1 -o img/bge1_m.png`

if_lo0=`/usr/local/bin/vnstati -vs -ne -i lo0 -o img/lo0.png`
if_lo0_m=`/usr/local/bin/vnstati -m -ne -i lo0 -o img/lo0_m.png`

if_sum=`/usr/local/bin/vnstati -s -ne -i bge0+bge1+lo0 -o img/sum.png`

if_top10=`/usr/local/bin/vnstati -t -ne -i bge0+bge1+lo0 -o img/top10.png`


ERR="vnstati executable missing or problem executing vnstati/writing images to disk!"


# content handling & output
echo Content-type: text/html
echo ""
echo ""


echo "<h3>traffic summary:</h3>"

if [ "$if_sum" ]; then
        echo "<p><img src=img/sum.png></p>"
else
        echo $ERR
fi


echo "<h3>top 10:</h3>"

if [ "$if_top10" ]; then
        echo "<p><img src=img/top10.png></p>"
else
        echo $ERR
fi


echo "<h3>traffic on interface:</h3>"

if [ "$if_bge0" ] && [ "$if_bge0_m" ]  && [ "$if_bge0_m" ] && [ "$if_bge1" ] && [ "$if_bge1_m" ] && [ "$if_lo0" ] && [ "$if_lo0_m" ]; then
        echo "<p><img src=img/bge0.png><br><img src=img/bge0_m.png></p>"
        echo "<p><img src=img/bge1.png><br><img src=img/bge1_m.png></p>"
        echo "<p><img src=img/lo0.png><br><img src=img/lo0_m.png></p>"
else
        echo $ERR
fi


echo "<h5>vnstat cgi wrapper script running on $SERVER_SOFTWARE via $GATEWAY_INTERFACE at $SERVER_NAME on port $SERVER_PORT</h5>"

#EOF

