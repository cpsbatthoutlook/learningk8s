#!/bin/bash
#node1 node2 node3 jnode3 jnode5 jnode4 
r="${@:2}"
x=$1
if [ "$x" == "all" ] 
then
 for x in node1 node2 node3 jnode3 jnode5 jnode4;do
          echo "Running \"$r\" on $x"
	  kubectl $r $x  
 done
else
         echo "Running \"$r\" on $x"
	 #echo kubectl  $r  $x
	 kubectl  $r  $x
fi
