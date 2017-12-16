#!/bin/bash


clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2)
workers=(8 16 32 64)

for r in "${reps[@]}"; do
	for wt in "${workers[@]}"; do
		python 3.2mem_parser.py 80 exp3.2_mw1_set_memr${r}wt${wt}_all_c.txt mw1_mem1r${r}wt${wt}_out.txt mw1_mem1r${r}wt${wt}_data.txt
	done
done 

reps=(3)


for r in "${reps[@]}"; do
	for wt in "${workers[@]}"; do
		if [ "${wt}" = "8" ] 
		then
			python 3.2mem_parser_with_nan.py 80 exp3.2_mw1_set_memr${r}wt${wt}_all_c.txt mw1_mem1r${r}wt${wt}_out.txt mw1_mem1r${r}wt${wt}_data.txt
		else
			python 3.2mem_parser.py 80 exp3.2_mw1_set_memr${r}wt${wt}_all_c.txt mw1_mem1r${r}wt${wt}_out.txt mw1_mem1r${r}wt${wt}_data.txt
		fi
	done
done
