#!/bin/bash



reps=(1 2 3)
workers=(8 32)



for wt in "${workers[@]}"; do
	for r in "${reps[@]}"; do
		printf>>STH_mw2_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"
		printf>>SRT_mw2_wt${wt}_tot.txt "r=${r}, wt=${wt}\n"

		cat STH_mw2_r${r}_wt${wt}.txt >> STH_mw2_wt${wt}_tot.txt
		cat SRT_mw2_r${r}_wt${wt}.txt >> SRT_mw2_wt${wt}_tot.txt

		printf>>STH_mw2_wt${wt}_tot.txt "\n"
		printf>>SRT_mw2_wt${wt}_tot.txt "\n"

	done

done 
echo "done"
