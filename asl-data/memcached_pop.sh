#!/bin/bash


ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=9000 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=900 --server=10.0.0.4 --clients=64 -t 2 &

ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=9001 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=900 --server=10.0.0.10 --clients=64 -t 2 &

ssh perlinig-ethz@perlinig-ethzforaslvms1.westeurope.cloudapp.azure.com memtier_benchmark --port=9002 --protocol=memcache_text --ratio=1:0 --expiry-range=9999-10000 --key-maximum=10000 -d 1024 --hide-histogram --test-time=900 --server=10.0.0.11 --clients=64 -t 2

