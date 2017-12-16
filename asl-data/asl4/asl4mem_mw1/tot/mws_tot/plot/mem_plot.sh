#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function th {
        (cat <<EndofMessage
set terminal png
set output 'th_mem.png'
set key right bottom
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Throughput on Memtier [SET] [ops/s]"
set title  "Throughput per Number of Clients"
set xrange [0:200] 
set yrange [0:10000]
plot "mws_wt8_tot.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, \
"mws_wt16_tot.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, \
"mws_wt32_tot.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, \
"mws_wt64_tot.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

function rt {
        (cat <<EndofMessage
set terminal png
set output 'rt_mem.png'
set key top left
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Response Time on Memtier [SET] [ms]"
set title  "Response Time per Number of Clients"
set xrange [0:200] 
set yrange [0:50]
plot "mws_wt8_tot.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, \
"mws_wt16_tot.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, \
"mws_wt32_tot.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, \
"mws_wt64_tot.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


th
rt

