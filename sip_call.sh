#!/bin/bash

# Need to change the path

#dir_path=/var/spool/asterisk/outgoing/
dir_path=/home/local/CORPORATE/naman/work/SIPp/SIPp/test_dir/
sipp_dir=/home/ubuntu/sippCall/

if [ $1 != "" ] || [ $2 != "" ] || [ $3 != "" ]
then
	for ((a=1;a<=$1;a++));
	do
		for ((i=1;i<=$2;i++));
    	 	do
		echo $sipp_dir"sipp.call"
   	 	`cp $sipp_dir"sipp.call"  $sipp_dir"sipp3_"$a"_"$i".call"`
   	 	`cp $sipp_dir"sipp3_"$a"_"$i".call" $dir_path`
		done
		
	 	printf "\n----- $a iteraton ------"`date +%d%m%y_%H%M%S`
	 	printf "\ncycle completed for $2 simultanious calls"
	 	printf "\n\n sleeping for $3 seconds ... \n"
    			 sleep $3;
done
else
	printf "\n Please run with three arguments:\n\n 1. Number of iterations\n 2. Number of simultanious calls\n 3. sleep seconds\n" 
fi


