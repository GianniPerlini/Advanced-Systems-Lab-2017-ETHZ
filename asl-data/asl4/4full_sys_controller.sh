#!/bin/bash

reps=(1 2 3)
workers=(8 16 32 64)
clients=(1 4 8 12 16 20 24 28 32)


./memcached_pop.sh

for rep in "${reps[@]}"; do

	for w in "${workers[@]}"; do

		for c in "${clients[@]}"; do	
			
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com java -jar asl17-project-mw.jar -l 10.0.0.7 -p 8998 -t ${w} -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 & 
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com java -jar asl17-project-mw.jar -l 10.0.0.8 -p 8999 -t ${w} -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 &
			sleep 4
 
			# start two memtier instances in parallel in each VM
			ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=${c} -t 1 >> exp4.1_mw1_mem1r${rep}wt${w}c${c}.txt 2>&1 &

			ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=${c} -t 1 >> exp4.1_mw2_mem1r${rep}wt${w}c${c}.txt 2>&1 &
			
			ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=${c} -t 1 >> exp4.1_mw1_mem2r${rep}wt${w}c${c}.txt 2>&1 &

			ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=${c} -t 1 >> exp4.1_mw2_mem2r${rep}wt${w}c${c}.txt 2>&1 &
			
			ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=${c} -t 1 >> exp4.1_mw1_mem3r${rep}wt${w}c${c}.txt 2>&1 &

			ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=${c} -t 1 >> exp4.1_mw2_mem3r${rep}wt${w}c${c}.txt 2>&1
			
			mv /home/gianni/Scrivania/exp4.1_mw1_mem1r${rep}wt${w}c${c}.txt /home/gianni/Scrivania/asl4vm1/mem1
			mv /home/gianni/Scrivania/exp4.1_mw2_mem1r${rep}wt${w}c${c}.txt /home/gianni/Scrivania/asl4vm1/mem2

			mv /home/gianni/Scrivania/exp4.1_mw1_mem2r${rep}wt${w}c${c}.txt /home/gianni/Scrivania/asl4vm2/mem1
			mv /home/gianni/Scrivania/exp4.1_mw2_mem2r${rep}wt${w}c${c}.txt /home/gianni/Scrivania/asl4vm2/mem2

			mv /home/gianni/Scrivania/exp4.1_mw1_mem3r${rep}wt${w}c${c}.txt /home/gianni/Scrivania/asl4vm3/mem1
			mv /home/gianni/Scrivania/exp4.1_mw2_mem3r${rep}wt${w}c${c}.txt /home/gianni/Scrivania/asl4vm3/mem2

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com pkill -n java
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com pkill -n java
			

			sleep 10

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Loads_S4.txt SL_${op}_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Server_Loads_S4.txt SL_${op}_r${rep}_wt${w}_c${c}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Errors.txt SE_${op}_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Server_Errors.txt SE_${op}_r${rep}_wt${w}_c${c}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Wrong_Requests.txt WR_${op}_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Wrong_Requests.txt WR_${op}_r${rep}_wt${w}_c${c}.txt

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Parse_Set.txt TParseS_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Set.txt TSendS_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Back_Set.txt TSBS_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQ_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv AR.txt AR_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Queue_Lenghts.txt QL_mw1_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Th_Per_WT.txt STHWT_mw1_r${rep}_wt${w}_c${c}.txt


			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Parse_Set.txt TParseS_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Send_Set.txt TSendS_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Send_Back_Set.txt TSBS_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQ_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv AR.txt AR_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_Th_Per_WT.txt STHWT_mw2_r${rep}_wt${w}_c${c}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Queue_Lenghts.txt QL_mw2_r${rep}_wt${w}_c${c}.txt
			
			scp perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/asl4mw1
			scp perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/asl4mw2

			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com rm *.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com rm *.txt
		done
	done

done


















