#!/bin/bash



reps=(1 2 3)
workers=(8 32)



for wt in "${workers[@]}"; do
	for r in "${reps[@]}"; do
		printf>>GTH_mw2_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"
		printf>>GRT_mw2_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"
		printf>>STH_mw2_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"
		printf>>SRT_mw2_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"

		cat GTH_mw2_r${r}_wt${wt}.txt >> GTH_mw2_wt${wt}_tot.txt
		cat GRT_mw2_r${r}_wt${wt}.txt >> GRT_mw2_wt${wt}_tot.txt
		cat STH_mw2_r${r}_wt${wt}.txt >> STH_mw2_wt${wt}_tot.txt
		cat SRT_mw2_r${r}_wt${wt}.txt >> SRT_mw2_wt${wt}_tot.txt

		printf>>GTH_mw2_wt${wt}_tot.txt "\n"
		printf>>GRT_mw2_wt${wt}_tot.txt "\n"
		printf>>STH_mw2_wt${wt}_tot.txt "\n"
		printf>>SRT_mw2_wt${wt}_tot.txt "\n"

	done

done 
echo "done"
