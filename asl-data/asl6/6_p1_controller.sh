#!/bin/bash

setcmd="./6_2k_p1.sh set 1:0"

./memcached_pop.sh
$setcmd
./6_2k_p1.sh get 0:1
./6_2k_p1.sh both  1:1

