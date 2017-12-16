#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function tps {
        (cat <<EndofMessage
set terminal png
set output 'tps.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Time waiting Memcached [GET] [ms]"
set title  "Time waiting Memcached per Number of Clients"
set xrange [0:72] 
set yrange [0:3]
plot "TPG_wt8_data.txt" index 00:00 using 1:(\$2/1000000):(\$3/1000000):xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, \
"TPG_wt16_data.txt" index 00:00 using 1:(\$2/1000000):(\$3/1000000):xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, \
"TPG_wt32_data.txt" index 00:00 using 1:(\$2/1000000):(\$3/1000000):xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, \
"TPG_wt64_data.txt" index 00:00 using 1:(\$2/1000000):(\$3/1000000):xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


function Tps {
    echo "=========== Time waiting Memcached Plot ============"
    echo "This function plots the Time waiting Memcached "
    echo "for GET operations with respect to"
    echo "the Number of Clients"
    echo "==========================================="
    tps

}

Tps

