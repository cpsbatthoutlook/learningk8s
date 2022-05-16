#!/bin/bash
#node1 node2 node3 jnode3 jnode5 jnode4 
b="${@:2}"
r=$1
echo "Running \"$b\" on $r"
if [ "$r" == "all" ] 
then
 for r in node1 node2 node3 jnode3 jnode5 jnode4;do
	  ssh $r  $b
 done
else
	 ssh $r  $b
fi
