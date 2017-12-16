#!/bin/bash

op="$1"
ratio="$2"

reps=(1 2 3)
workers=(8 32)


# 1 mw, 3 servers
for rep in "${reps[@]}"; do

	for w in "${workers[@]}"; do
		
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com java -jar asl17-project-mw.jar -l 10.0.0.7 -p 8998 -t ${w} -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 & 
		sleep 4

		# start two memtier instances in parallel in each VM
		ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_1mw_3s_mem11r${rep}wt${w}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_1mw_3s_mem12r${rep}wt${w}.txt 2>&1 &
		
		ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_1mw_3s_mem21r${rep}wt${w}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_1mw_3s_mem22r${rep}wt${w}.txt 2>&1 &
		
		ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_1mw_3s_mem31r${rep}wt${w}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_1mw_3s_mem32r${rep}wt${w}.txt 2>&1
		
		mv /home/gianni/Scrivania/exp6_${op}_1mw_3s_mem11r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_1mw_3s_mem1/mem1
		mv /home/gianni/Scrivania/exp6_${op}_1mw_3s_mem12r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_1mw_3s_mem1/mem2

		mv /home/gianni/Scrivania/exp6_${op}_1mw_3s_mem21r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_1mw_3s_mem2/mem1
		mv /home/gianni/Scrivania/exp6_${op}_1mw_3s_mem22r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_1mw_3s_mem2/mem2

		mv /home/gianni/Scrivania/exp6_${op}_1mw_3s_mem31r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_1mw_3s_mem3/mem1
		mv /home/gianni/Scrivania/exp6_${op}_1mw_3s_mem32r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_1mw_3s_mem3/mem2
		
		sleep 3

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com pkill -n java
		
		sleep 15

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Errors.txt SE_r${rep}_wt${w}.txt

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Wrong_Requests.txt WR_r${rep}_wt${w}.txt

		if [ "$1" = "set" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQS_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_r${rep}_wt${w}.txt

		elif [ "$1" = "get" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_get_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_get_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_r${rep}_wt${w}.txt

		else
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_get_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_get_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQS_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_r${rep}_wt${w}.txt
		fi	
		
		scp perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/asl6_${op}_1mw_3s_mw

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com rm *.txt

	done

done

# 2 mw, 3 servers

for rep in "${reps[@]}"; do

	for w in "${workers[@]}"; do
		
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com java -jar asl17-project-mw.jar -l 10.0.0.7 -p 8998 -t ${w} -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 & 
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com java -jar asl17-project-mw.jar -l 10.0.0.8 -p 8999 -t ${w} -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 & 
		sleep 4

		# start two memtier instances in parallel in each VM
		ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_2mw_3s_mem11r${rep}wt${w}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=32 -t 1 >> exp6_${op}_2mw_3s_mem12r${rep}wt${w}.txt 2>&1 &
		
		ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_2mw_3s_mem21r${rep}wt${w}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=32 -t 1 >> exp6_${op}_2mw_3s_mem22r${rep}wt${w}.txt 2>&1 &
		
		ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=32 -t 1 >> exp6_${op}_2mw_3s_mem31r${rep}wt${w}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=${ratio} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=32 -t 1 >> exp6_${op}_2mw_3s_mem32r${rep}wt${w}.txt 2>&1
		
		mv /home/gianni/Scrivania/exp6_${op}_2mw_3s_mem11r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_2mw_3s_mem1/mem1
		mv /home/gianni/Scrivania/exp6_${op}_2mw_3s_mem12r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_2mw_3s_mem1/mem2

		mv /home/gianni/Scrivania/exp6_${op}_2mw_3s_mem21r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_2mw_3s_mem2/mem1
		mv /home/gianni/Scrivania/exp6_${op}_2mw_3s_mem22r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_2mw_3s_mem2/mem2

		mv /home/gianni/Scrivania/exp6_${op}_2mw_3s_mem31r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_2mw_3s_mem3/mem1
		mv /home/gianni/Scrivania/exp6_${op}_2mw_3s_mem32r${rep}wt${w}.txt /home/gianni/Scrivania/asl6_${op}_2mw_3s_mem3/mem2

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com pkill -n java
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com pkill -n java

		sleep 3
		
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com pkill -n java
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com pkill -n java
		
		sleep 20



		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Errors.txt SE_mw1_r${rep}_wt${w}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Server_Errors.txt SE_mw2_r${rep}_wt${w}.txt

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Wrong_Requests.txt WR_mw1_r${rep}_wt${w}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Wrong_Requests.txt WR_mw2_r${rep}_wt${w}.txt


		if [ "$1" = "set" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQS_mw1_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_mw1_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQS_mw2_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_mw2_r${rep}_wt${w}.txt
		
		elif [ "$1" = "get" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_mw1_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_mw2_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_mw1_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_mw1_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_mw2_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_mw2_r${rep}_wt${w}.txt

		else
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_mw1_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_mw2_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQS_mw1_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_mw1_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQS_mw2_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_mw2_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_mw1_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_mw1_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_mw1_r${rep}_wt${w}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_mw2_r${rep}_wt${w}.txt	
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_mw2_r${rep}_wt${w}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_mw2_r${rep}_wt${w}.txt

		fi

		scp perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/asl6_${op}_2mw_3s_mw1
		scp perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/asl6_${op}_2mw_3s_mw2

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com rm *.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com rm *.txt

	done

done















