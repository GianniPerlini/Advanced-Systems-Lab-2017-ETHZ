#!/bin/bash



reps=(1 2 3)
workers=(8 32)



for wt in "${workers[@]}"; do
	for r in "${reps[@]}"; do
		printf>>GTH_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"
		printf>>GRT_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"
		printf>>STH_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"
		printf>>SRT_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"

		cat GTH_r${r}_wt${wt}.txt >> GTH_wt${wt}_tot.txt
		cat GRT_r${r}_wt${wt}.txt >> GRT_wt${wt}_tot.txt
		cat STH_r${r}_wt${wt}.txt >> STH_wt${wt}_tot.txt
		cat SRT_r${r}_wt${wt}.txt >> SRT_wt${wt}_tot.txt

		printf>>GTH_wt${wt}_tot.txt "\n"
		printf>>GRT_wt${wt}_tot.txt "\n"
		printf>>STH_wt${wt}_tot.txt "\n"
		printf>>SRT_wt${wt}_tot.txt "\n"

	done

done 
echo "done"
