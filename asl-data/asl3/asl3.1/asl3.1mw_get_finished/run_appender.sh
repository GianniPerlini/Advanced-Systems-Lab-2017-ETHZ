#!/bin/bash


clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
workers=(8 16 32 64)


for c in "${clients[@]}"; do
	for wt in "${workers[@]}"; do
		for r in "${reps[@]}"; do
			printf>>QL_get_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>AR_get_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>GTH_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TIQ_get_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TParseG_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TSendG_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TPG_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TSBG_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>GRT_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"

			cat QL_get_r${r}_wt${wt}_c${c}.txt >> QL_get_c${c}_wt${wt}_tot.txt
			cat AR_get_r${r}_wt${wt}_c${c}.txt >> AR_get_c${c}_wt${wt}_tot.txt
			cat GTH_r${r}_wt${wt}_c${c}.txt >> GTH_c${c}_wt${wt}_tot.txt
			cat TIQ_get_r${r}_wt${wt}_c${c}.txt >> TIQ_get_c${c}_wt${wt}_tot.txt
			cat TParseG_r${r}_wt${wt}_c${c}.txt >> TParseG_c${c}_wt${wt}_tot.txt
			cat TSendG_r${r}_wt${wt}_c${c}.txt >> TSendG_c${c}_wt${wt}_tot.txt
			cat TPG_r${r}_wt${wt}_c${c}.txt >> TPG_c${c}_wt${wt}_tot.txt
			cat TSBG_r${r}_wt${wt}_c${c}.txt >> TSBG_c${c}_wt${wt}_tot.txt
			cat GRT_r${r}_wt${wt}_c${c}.txt >> GRT_c${c}_wt${wt}_tot.txt

			printf>>QL_get_c${c}_wt${wt}_tot.txt "\n"
			printf>>AR_get_c${c}_wt${wt}_tot.txt "\n"
			printf>>GTH_c${c}_wt${wt}_tot.txt "\n"
			printf>>TIQ_get_c${c}_wt${wt}_tot.txt "\n"
			printf>>TParseG_c${c}_wt${wt}_tot.txt "\n"
			printf>>TSendG_c${c}_wt${wt}_tot.txt "\n"
			printf>>TSBG_c${c}_wt${wt}_tot.txt "\n"
			printf>>TPG_c${c}_wt${wt}_tot.txt "\n"
			printf>>GRT_c${c}_wt${wt}_tot.txt "\n"

		done
	done
done 
echo "done"
