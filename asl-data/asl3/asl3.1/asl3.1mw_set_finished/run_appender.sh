#!/bin/bash


clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
workers=(8 16 32 64)


for c in "${clients[@]}"; do
	for wt in "${workers[@]}"; do
		for r in "${reps[@]}"; do
			printf>>QL_set_set_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>AR_set_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>STH_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TIQ_set_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TParseS_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TSendS_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TPS_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TSBS_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>SRT_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"

			cat QL_set_r${r}_wt${wt}_c${c}.txt >> QL_set_c${c}_wt${wt}_tot.txt
			cat AR_set_r${r}_wt${wt}_c${c}.txt >> AR_set_c${c}_wt${wt}_tot.txt
			cat STH_r${r}_wt${wt}_c${c}.txt >> STH_c${c}_wt${wt}_tot.txt
			cat TIQ_set_r${r}_wt${wt}_c${c}.txt >> TIQ_set_c${c}_wt${wt}_tot.txt
			cat TParseS_r${r}_wt${wt}_c${c}.txt >> TParseS_c${c}_wt${wt}_tot.txt
			cat TSendS_r${r}_wt${wt}_c${c}.txt >> TSendS_c${c}_wt${wt}_tot.txt
			cat TPS_r${r}_wt${wt}_c${c}.txt >> TPS_c${c}_wt${wt}_tot.txt
			cat TSBS_r${r}_wt${wt}_c${c}.txt >> TSBS_c${c}_wt${wt}_tot.txt
			cat SRT_r${r}_wt${wt}_c${c}.txt >> SRT_c${c}_wt${wt}_tot.txt

			printf>>QL_set_c${c}_wt${wt}_tot.txt "\n"
			printf>>AR_set_c${c}_wt${wt}_tot.txt "\n"
			printf>>STH_c${c}_wt${wt}_tot.txt "\n"
			printf>>TIQ_set_c${c}_wt${wt}_tot.txt "\n"
			printf>>TParseS_c${c}_wt${wt}_tot.txt "\n"
			printf>>TSendS_c${c}_wt${wt}_tot.txt "\n"
			printf>>TSBS_c${c}_wt${wt}_tot.txt "\n"
			printf>>TPS_c${c}_wt${wt}_tot.txt "\n"
			printf>>SRT_c${c}_wt${wt}_tot.txt "\n"

		done
	done
done 
echo "done"
