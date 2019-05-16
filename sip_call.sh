#!/bin/bash
dir_path=/var/spool/asterisk/outgoing/
if [ $1 != "" ] || [ $2 != "" ] || [ $3 != "" ]
then
	for ((a=1;a<=$1;a++));
	do
		for ((i=1;i<=5;i++));
    	 	do
   	 	`cp "/home/ubuntu/sipCalls/sipp.call"  "/home/ubuntu/sipCalls/sipp3_"$a"_"$i".call"`
   	 	`cp "/home/ubuntu/sipCalls/sipp3_"$a"_"$i".call" $dir_path`
		done
		
	 	printf "\n----- $a iteraton ------"`date +%d%m%y_%H%M%S`
	 	printf "\ncycle completed for $2 simultanious calls"
	 	printf "\n\n sleeping for $2 seconds ... \n"
    			 sleep $2;
done
else
	printf "\n Please run with three arguments:\n\n 1. Number of iterations\n 2. Number of simultanious calls\n 3. sleep seconds\n" 
fi


