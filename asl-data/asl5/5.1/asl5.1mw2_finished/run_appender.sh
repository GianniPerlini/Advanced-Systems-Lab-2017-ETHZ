#!/bin/bash


op="$1"

clients=(1 4 8 12 16 20 24 28 32)
reps=(1 2 3)
ks=(1 3 6 9)



for k in "${ks[@]}"; do
	for r in "${reps[@]}"; do
		printf>>QL_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>AR_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>STH_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TIQS_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TIQG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TParseS_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TSendS_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TPS_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TSBS_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>SRT_${op}_k${k}_tot.txt "r=${r}, k${k}\n"

		cat QL_${op}_r${r}_k${k}.txt >> QL_${op}_k${k}_tot.txt
		cat AR_${op}_r${r}_k${k}.txt >> AR_${op}_k${k}_tot.txt
		cat STH_${op}_r${r}_k${k}.txt >> STH_${op}_k${k}_tot.txt
		cat TIQS_${op}_r${r}_k${k}.txt >> TIQS_${op}_k${k}_tot.txt
		cat TIQG_${op}_r${r}_k${k}.txt >> TIQG_${op}_k${k}_tot.txt
		cat TParseS_${op}_r${r}_k${k}.txt >> TParseS_${op}_k${k}_tot.txt
		cat TSendS_${op}_r${r}_k${k}.txt >> TSendS_${op}_k${k}_tot.txt
		cat TPS_${op}_r${r}_k${k}.txt >> TPS_${op}_k${k}_tot.txt
		cat TSBS_${op}_r${r}_k${k}.txt >> TSBS_${op}_k${k}_tot.txt
		cat SRT_${op}_r${r}_k${k}.txt >> SRT_${op}_k${k}_tot.txt

		printf>>QL_${op}_k${k}_tot.txt "\n"
		printf>>AR_${op}_k${k}_tot.txt "\n"
		printf>>STH_${op}_k${k}_tot.txt "\n"
		printf>>TIQS_${op}_k${k}_tot.txt "\n"
		printf>>TIQG_${op}_k${k}_tot.txt "\n"
		printf>>TParseS_${op}_k${k}_tot.txt "\n"
		printf>>TSendS_${op}_k${k}_tot.txt "\n"
		printf>>TSBS_${op}_k${k}_tot.txt "\n"
		printf>>TPS_${op}_k${k}_tot.txt "\n"
		printf>>SRT_${op}_k${k}_tot.txt "\n"

	done
done 
echo "done"

ks=(3 6 9)

for k in "${ks[@]}"; do
	for r in "${reps[@]}"; do
		printf>>MGTH_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TParseMG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TSendMG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TPMG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TSRBMG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>RTMG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"

		cat MGTH_${op}_r${r}_k${k}.txt >> MGTH_${op}_k${k}_tot.txt
		cat TParseMG_${op}_r${r}_k${k}.txt >> TParseMG_${op}_k${k}_tot.txt
		cat TSendMG_${op}_r${r}_k${k}.txt >> TSendMG_${op}_k${k}_tot.txt
		cat TPMG_${op}_r${r}_k${k}.txt >> TPMG_${op}_k${k}_tot.txt
		cat TSRBMG_${op}_r${r}_k${k}.txt >> TSRBMG_${op}_k${k}_tot.txt
		cat RTMG_${op}_r${r}_k${k}.txt >> RTMG_${op}_k${k}_tot.txt

		printf>>MGTH_${op}_k${k}_tot.txt "\n"
		printf>>TParseMG_${op}_k${k}_tot.txt "\n"
		printf>>TSendMG_${op}_k${k}_tot.txt "\n"
		printf>>TSBMG_${op}_k${k}_tot.txt "\n"
		printf>>TPMG_${op}_k${k}_tot.txt "\n"
		printf>>RTMG_${op}_k${k}_tot.txt "\n"

	done
done
echo "done"

ks=(1)

for k in "${ks[@]}"; do
	for r in "${reps[@]}"; do
		printf>>GTH_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TParseG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TSendG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TPG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>TSBG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"
		printf>>RTG_${op}_k${k}_tot.txt "r=${r}, k${k}\n"

		cat GTH_${op}_r${r}_k${k}.txt >> GTH_${op}_k${k}_tot.txt
		cat TParseG_${op}_r${r}_k${k}.txt >> TParseG_${op}_k${k}_tot.txt
		cat TSendG_${op}_r${r}_k${k}.txt >> TSendG_${op}_k${k}_tot.txt
		cat TPG_${op}_r${r}_k${k}.txt >> TPG_${op}_k${k}_tot.txt
		cat TSBG_${op}_r${r}_k${k}.txt >> TSBG_${op}_k${k}_tot.txt
		cat GRT_${op}_r${r}_k${k}.txt >> GRT_${op}_k${k}_tot.txt

		printf>>GTH_${op}_k${k}_tot.txt "\n"
		printf>>TParseG_${op}_k${k}_tot.txt "\n"
		printf>>TSendG_${op}_k${k}_tot.txt "\n"
		printf>>TSBG_${op}_k${k}_tot.txt "\n"
		printf>>TPG_${op}_k${k}_tot.txt "\n"
		printf>>GRT_${op}_k${k}_tot.txt "\n"

	done
done
echo "done"
