#!/bin/bash


clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
workers=(8 16 32 64)

for r in "${reps[@]}"; do
	for wt in "${workers[@]}"; do
		python 4.1mem_parser.py 80 exp4.1_mw1_mem1r${r}wt${wt}_all_c.txt mw1_mem1r${r}wt${wt}_out.txt mw1_mem1r${r}wt${wt}_data.txt
	done
done 

python 4.1mem_parser.py 80 exp4.1_mw1_mem1r1wt8_all_c.txt mw1_mem1r1wt8_out.txt mw1_mem1r1wt8_data.txt
