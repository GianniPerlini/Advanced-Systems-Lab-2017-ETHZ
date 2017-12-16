#!/bin/bash


op="$1"

clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
workers=(8 16 32 64)


for c in "${clients[@]}"; do
	for wt in "${workers[@]}"; do
		for r in "${reps[@]}"; do
			printf>>QL_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>AR_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>STH_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TIQ_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TParseS_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TSendS_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TPS_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TSBS_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>SRT_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>STHWT_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"

			cat QL_${op}_r${r}_wt${wt}_c${c}.txt >> QL_${op}_c${c}_wt${wt}_tot.txt
			cat AR_${op}_r${r}_wt${wt}_c${c}.txt >> AR_${op}_c${c}_wt${wt}_tot.txt
			cat STH_${op}_r${r}_wt${wt}_c${c}.txt >> STH_${op}_c${c}_wt${wt}_tot.txt
			cat TIQ_${op}_r${r}_wt${wt}_c${c}.txt >> TIQ_${op}_c${c}_wt${wt}_tot.txt
			cat TParseS_${op}_r${r}_wt${wt}_c${c}.txt >> TParseS_${op}_c${c}_wt${wt}_tot.txt
			cat TSendS_${op}_r${r}_wt${wt}_c${c}.txt >> TSendS_${op}_c${c}_wt${wt}_tot.txt
			cat TPS_${op}_r${r}_wt${wt}_c${c}.txt >> TPS_${op}_c${c}_wt${wt}_tot.txt
			cat TSBS_${op}_r${r}_wt${wt}_c${c}.txt >> TSBS_${op}_c${c}_wt${wt}_tot.txt
			cat SRT_${op}_r${r}_wt${wt}_c${c}.txt >> SRT_${op}_c${c}_wt${wt}_tot.txt
			cat STHWT_${op}_r${r}_wt${wt}_c${c}.txt >> STHWT_${op}_c${c}_wt${wt}_tot.txt

			printf>>QL_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>AR_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>STH_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TIQ_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TParseS_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TSendS_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TSBS_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TPS_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>SRT_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>STHWT_${op}_c${c}_wt${wt}_tot.txt "\n"

		done
	done
done 
echo "done"
