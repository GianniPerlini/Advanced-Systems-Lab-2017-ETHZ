#!/bin/bash


op="$1"

clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
workers=(8 16 32 64)


for c in "${clients[@]}"; do
	for wt in "${workers[@]}"; do
		for r in "${reps[@]}"; do
			printf>>QL_get_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>AR_get_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>GTH_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TIQ_get_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TParseG_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TSendG_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TPG_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>TSBG_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"
			printf>>GRT_${op}_c${c}_wt${wt}_tot.txt "r=${r}, wt=${wt}, c=${c}\n"

			cat QL_get_${op}_r${r}_wt${wt}_c${c}.txt >> QL_get_${op}_c${c}_wt${wt}_tot.txt
			cat AR_get_${op}_r${r}_wt${wt}_c${c}.txt >> AR_get_${op}_c${c}_wt${wt}_tot.txt
			cat GTH_${op}_r${r}_wt${wt}_c${c}.txt >> GTH_${op}_c${c}_wt${wt}_tot.txt
			cat TIQ_get_${op}_r${r}_wt${wt}_c${c}.txt >> TIQ_get_${op}_c${c}_wt${wt}_tot.txt
			cat TParseG_${op}_r${r}_wt${wt}_c${c}.txt >> TParseG_${op}_c${c}_wt${wt}_tot.txt
			cat TSendG_${op}_r${r}_wt${wt}_c${c}.txt >> TSendG_${op}_c${c}_wt${wt}_tot.txt
			cat TPG_${op}_r${r}_wt${wt}_c${c}.txt >> TPG_${op}_c${c}_wt${wt}_tot.txt
			cat TSBG_${op}_r${r}_wt${wt}_c${c}.txt >> TSBG_${op}_c${c}_wt${wt}_tot.txt
			cat GRT_${op}_r${r}_wt${wt}_c${c}.txt >> GRT_${op}_c${c}_wt${wt}_tot.txt

			printf>>QL_get_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>AR_get_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>GTH_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TIQ_get_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TParseG_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TSendG_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TSBG_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>TPG_${op}_c${c}_wt${wt}_tot.txt "\n"
			printf>>GRT_${op}_c${c}_wt${wt}_tot.txt "\n"

		done
	done
done 
echo "done"
