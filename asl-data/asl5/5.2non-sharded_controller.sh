#!/bin/bash

reps=(1 2 3)
keysize=(1)

#./memcached_pop.sh

for rep in "${reps[@]}"; do
	for k in "${keysize[@]}"; do

		if [ "${k}" = "6" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com java -jar asl17-project-mw-ex5.jar -l 10.0.0.7 -p 8998 -t 64 -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 -k true & 
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com java -jar asl17-project-mw-ex5.jar -l 10.0.0.8 -p 8999 -t 64 -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 -k true &
			sleep 4
		else
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com java -jar asl17-project-mw-ex5.jar -l 10.0.0.7 -p 8998 -t 64 -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 -k false & 
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com java -jar asl17-project-mw-ex5.jar -l 10.0.0.8 -p 8999 -t 64 -s false -m 10.0.0.4:9000 10.0.0.10:9001 10.0.0.11:9002 -k false &
			sleep 4
		fi


		# start two memtier instances in parallel in each VM
		ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=1:${k} --multi-key-get=${k} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=2 -t 1 --client-stats=vm1mem1_r${rep}k${k} >> exp5.2_vm1_mem1r${rep}k${k}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=1:${k} --multi-key-get=${k} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=2 -t 1 --client-stats=vm1mem2_r${rep}k${k} >> exp5.2_vm1_mem2r${rep}k${k}.txt 2>&1 &
		
		ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=1:${k} --multi-key-get=${k} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=2 -t 1 --client-stats=vm2mem1_r${rep}k${k} >> exp5.2_vm2_mem1r${rep}k${k}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=1:${k} --multi-key-get=${k} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=2 -t 1 --client-stats=vm2mem2_r${rep}k${k} >> exp5.2_vm2_mem2r${rep}k${k}.txt 2>&1 &
		
		ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com memtier_benchmark --port=8998 --protocol=memcache_text --ratio=1:${k} --multi-key-get=${k} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.7 --clients=2 -t 1 --client-stats=vm3mem1_r${rep}k${k} >> exp5.2_vm3_mem1r${rep}k${k}.txt 2>&1 &

		ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com memtier_benchmark --port=8999 --protocol=memcache_text --ratio=1:${k} --multi-key-get=${k} --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=80 --server=10.0.0.8 --clients=2 -t 1 --client-stats=vm3mem2_r${rep}k${k} >> exp5.2_vm3_mem2r${rep}k${k}.txt 2>&1
		
		mv /home/gianni/Scrivania/exp5.2_vm1_mem1r${rep}k${k}.txt /home/gianni/Scrivania/ASL5.2vm1/mem1
		mv /home/gianni/Scrivania/exp5.2_vm1_mem2r${rep}k${k}.txt /home/gianni/Scrivania/ASL5.2vm1/mem2
		scp perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com:/home/perlinig-ethz/vm1mem1_r${rep}k${k}-*.csv /home/gianni/Scrivania/ASL5.2vm1/mem1
		scp perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com:/home/perlinig-ethz/vm1mem2_r${rep}k${k}-*.csv /home/gianni/Scrivania/ASL5.2vm1/mem2

		mv /home/gianni/Scrivania/exp5.2_vm2_mem1r${rep}k${k}.txt /home/gianni/Scrivania/ASL5.2vm2/mem1
		mv /home/gianni/Scrivania/exp5.2_vm2_mem2r${rep}k${k}.txt /home/gianni/Scrivania/ASL5.2vm2/mem2
		scp perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com:/home/perlinig-ethz/vm2mem1_r${rep}k${k}-*.csv /home/gianni/Scrivania/ASL5.2vm2/mem1
		scp perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com:/home/perlinig-ethz/vm2mem2_r${rep}k${k}-*.csv /home/gianni/Scrivania/ASL5.2vm2/mem2

		mv /home/gianni/Scrivania/exp5.2_vm3_mem1r${rep}k${k}.txt /home/gianni/Scrivania/ASL5.2vm3/mem1
		mv /home/gianni/Scrivania/exp5.2_vm3_mem2r${rep}k${k}.txt /home/gianni/Scrivania/ASL5.2vm3/mem2
		scp perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com:/home/perlinig-ethz/vm3mem1_r${rep}k${k}-*.csv /home/gianni/Scrivania/ASL5.2vm3/mem1
		scp perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com:/home/perlinig-ethz/vm3mem2_r${rep}k${k}-*.csv /home/gianni/Scrivania/ASL5.2vm3/mem2

		ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com rm *.csv
		ssh perlinig-ethz@perlinig-ethzforaslvms2.westeurope.cloudapp.azure.com rm *.csv
		ssh perlinig-ethz@perlinig-ethzforaslvms3.westeurope.cloudapp.azure.com rm *.csv

		sleep 2
		
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com pkill -n java
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com pkill -n java
		
		sleep 20


		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Errors.txt SE_r${rep}_wt${w}_c${c}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Server_Errors.txt SE_r${rep}_wt${w}_c${c}.txt

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Wrong_Requests.txt WR_r${rep}_wt${w}_c${c}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Wrong_Requests.txt WR_r${rep}_wt${w}_c${c}.txt


		if [ "${k}" = "1" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Parse_Get.txt TParseG_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Get.txt TSendG_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Back_Get.txt TSBG_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_mw1_r${rep}_k${k}.txt
		else
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv MGTH.txt MGTH_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv RTMG.txt RTMG_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv TParseMG.txt TParseMG_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv TPMG.txt TPMG_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv TSendMG.txt TSendMG_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv TSRBMG.txt TSRBMG_mw1_r${rep}_k${k}.txt
		
		fi

		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_Th_Per_WT.txt STHWT_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Th_Per_WT.txt STHWT_mw1_r${rep}_k${k}.txt

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Parse_Set.txt TParseS_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Set.txt TSendS_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_To_Send_Back_Set.txt TSBS_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQS_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv AR.txt AR_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Queue_Lenghts.txt QL_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv KC.txt KC_mw1_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_mw1_r${rep}_k${k}.txt

		if [ "${k}" = "6" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv singleGetRT singleGRt_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv singleMgRt singleMgRt_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com mv singleSetRt singleSRt_mw1_r${rep}_k${k}.txt
		fi


		if [ "${k}" = "1" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Cache_Misses.txt CM_mw1_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Server_Loads.txt SL_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Parse_Get.txt TParseG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Send_Get.txt TSendG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Send_Back_Get.txt TSBG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Processing_Get.txt TPG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Get_Throughputs.txt GTH_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Get_RT.txt GRT_mw2_r${rep}_k${k}.txt
		else
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv MGTH.txt MGTH_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv RTMG.txt RTMG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv TParseMG.txt TParseMG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv TPMG.txt TPMG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv TSendMG.txt TSendMG_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv TSRBMG.txt TSRBMG_mw2_r${rep}_k${k}.txt
		
		fi

		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Parse_Set.txt TParseS_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Send_Set.txt TSendS_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_To_Send_Back_Set.txt TSBS_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Processing_Set.txt TPS_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Queue_Set.txt TIQS_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_Throughputs.txt STH_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Set_RT.txt SRT_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv AR.txt AR_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Queue_Lenghts.txt QL_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv KC.txt KC_mw2_r${rep}_k${k}.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv Times_In_Queue_Get.txt TIQG_mw2_r${rep}_k${k}.txt


		if [ "${k}" = "6" ] 
		then
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv singleGetRT singleGRt_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv singleMgRt singleMgRt_mw2_r${rep}_k${k}.txt
			ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com mv singleSetRt singleSRt_mw2_r${rep}_k${k}.txt
		fi

		scp perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/ASL5.2mw1
		scp perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com:/home/perlinig-ethz/*.txt /home/gianni/Scrivania/ASL5.2mw2

		ssh perlinig-ethz@perlinig-ethzforaslvms4.westeurope.cloudapp.azure.com rm *.txt
		ssh perlinig-ethz@perlinig-ethzforaslvms5.westeurope.cloudapp.azure.com rm *.txt
	done
done


















