#!/bin/bash

reps=(1 2 3)
workers=(8 16 32 64)
clients=(1 4 8 12 16 20 24 28 32)

for rep in "${reps[@]}"; do
	./memcached_pop.sh
	for w in "${workers[@]}"; do

		for c in "${clients[@]}"; do	

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com java -jar asl17-project-mw.jar -l 10.0.0.7 -p 8999 -t ${w} -s false -m 10.0.0.4:9000 & 
			sleep 3

			ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=0:1 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=${c} -t 2 >> exp3.1_get_memr${rep}wt${w}c${c}.txt 2>&1
			
			mv /home/gianni/Scrivania/*.txt /home/gianni/Scrivania/bl3.1mem_get
			
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com pkill -n java
			
			sleep 15


			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_get_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_get_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Parse_Get.txt TParseG_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Get.txt TSendG_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Back_Get.txt TSBG_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue.txt TIQ_get_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv AR.txt AR_get_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Queue_Lenghts.txt QL_get_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_Th_Per_WT.txt GTHWT_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv GSTWT.txt GSTWT_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Errors.txt SE_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Wrong_Requests.txt WR_r${rep}_wt${w}_c${c}.txt


			scp perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/bl3.1mw_get
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com rm *.txt

		done
	done
		
done

:'

SET

./memcached_pop.sh

for rep in "${reps[@]}"; do

	for w in "${workers[@]}"; do

		for c in "${clients[@]}"; do	

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com java -jar asl17-project-mw.jar -l 10.0.0.7 -p 8999 -t ${w} -s false -m 10.0.0.4:9000 & 
			sleep 4

			ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=${c} -t 2 >> exp3.1_set_memr${rep}wt${w}c${c}.txt 2>&1
			
			mv /home/gianni/Scrivania/*.txt /home/gianni/Scrivania/bl3.1mem_set
			
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com pkill -n java
			
			sleep 15

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Parse_Set.txt TParseS_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Set.txt TSendS_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Back_Set.txt TSBS_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue.txt TIQ_set_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv AR.txt AR_set_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Queue_Lenghts.txt QL_set_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Th_Per_WT.txt STHWT_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv SSTWT.txt SSTWT_r${rep}_wt${w}_c${c}.txt

			scp perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/bl3.1mw_set
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com rm *.txt

		done
	done

done
'
