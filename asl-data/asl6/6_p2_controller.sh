#!/bin/bash

setcmd="./6_2k_p2.sh set 1:0"

#./memcached_pop.sh
#$setcmd
#./memcached_pop.sh
./6_2k_p2.sh get 0:1
./memcached_pop.sh
./6_2k_p2.sh both  1:1
