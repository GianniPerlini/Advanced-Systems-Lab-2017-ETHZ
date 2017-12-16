#!/bin/bash


op="$1"

clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
workers=(8 16 32 64)


for c in "${clients[@]}"; do
	for wt in "${workers[@]}"; do
		for r in "${reps[@]}"; do
			printf>>TParseG_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			cat TParseG_${op}_r${r}_wt${wt}_c${c}.txt >> TParseG_${op}_c${c}_wt${wt}_tot.txt
			printf>>TParseG_${op}_c${c}_wt${wt}_tot.txt "\n"
		done
	done
done 
echo "done"
