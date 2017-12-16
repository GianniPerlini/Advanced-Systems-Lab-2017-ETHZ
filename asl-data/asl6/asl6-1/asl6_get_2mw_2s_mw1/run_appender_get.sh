#!/bin/bash



reps=(1 2 3)
workers=(8 32)



for wt in "${workers[@]}"; do
	for r in "${reps[@]}"; do
		printf>>GTH_mw1_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"
		printf>>GRT_mw1_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"

		cat GTH_mw1_r${r}_wt${wt}.txt >> GTH_mw1_wt${wt}_tot.txt
		cat GRT_mw1_r${r}_wt${wt}.txt >> GRT_mw1_wt${wt}_tot.txt

		printf>>GTH_mw1_wt${wt}_tot.txt "\n"
		printf>>GRT_mw1_wt${wt}_tot.txt "\n"

	done

done 
echo "done"
