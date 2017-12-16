#!/bin/bash


clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
workers=(8 16 32 64)

for r in "${reps[@]}"; do
	for wt in "${workers[@]}"; do
		for c in "${clients[@]}"; do			
			cat exp3.2_mw1_set_memr${r}wt${wt}c${c}.txt >> exp3.2_mw1_set_memr${r}wt${wt}_all_c.txt
			
			printf>>exp3.2_mw1_set_memr${r}wt${wt}_all_c.txt "\n"
			
		done
	done
done 

