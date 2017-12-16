#!/bin/bash

cmd="python baseline1_parser_all_set.py 90 baseline_set_rep1_p2.txt bl1_set_out.txt bl1_set_data.txt"
echo $cmd
$cmd

cmd="python baseline1_parser_all_set.py 90 baseline_set_rep2_p2.txt bl2_set_out.txt bl2_set_data.txt"
echo $cmd
$cmd

cmd="python baseline1_parser_all_set.py 90 baseline_set_rep3_p2.txt bl3_set_out.txt bl3_set_data.txt"
echo $cmd
$cmd

cmd="python baseline1_parser_all_get.py 90 baseline_get_rep1_p2.txt bl1_get_out.txt bl1_get_data.txt"
echo $cmd
$cmd

cmd="python baseline1_parser_all_get.py 90 baseline_get_rep2_p2.txt bl2_get_out.txt bl2_get_data.txt"
echo $cmd
$cmd

cmd="python baseline1_parser_all_get.py 90 baseline_get_rep3_p2.txt bl3_get_out.txt bl3_get_data.txt"
echo $cmd
$cmd

cmd="python avg_btw_run_get.py"
echo $cmd
$cmd


cmd="python avg_btw_run_set.py"
echo $cmd
$cmd
