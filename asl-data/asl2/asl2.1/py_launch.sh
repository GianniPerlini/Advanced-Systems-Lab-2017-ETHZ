#!/bin/bash

vms=(1 2 3)
rep=(1 2 3)

for r in "${rep[@]}"; do
	for vm in "${vms[@]}"; do
		python baseline1_parser_all_get.py 80 baseline_get_rep${r}vm${vm}.txt bl${r}vm${vm}_get_out.txt bl${r}vm${vm}_get_data.txt
	
	done 
done

for r in "${rep[@]}"; do
	for vm in "${vms[@]}"; do
		python baseline_parser_all_set.py 80 baseline_set_rep${r}vm${vm}.txt bl${r}vm${vm}_set_out.txt bl${r}vm${vm}_set_data.txt
	
	done 
done
