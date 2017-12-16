#!/bin/bash


clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
workers=(8 16 32 64)

for r in "${reps[@]}"; do
	for wt in "${workers[@]}"; do
		python 3.1mem_parser.py 80 exp3.1_set_memr${r}wt${wt}_all_c.txt set_memr${r}wt${wt}_out.txt set_memr${r}wt${wt}_data.txt
	done
done 

