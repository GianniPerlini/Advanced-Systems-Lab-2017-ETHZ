#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function tp {
        (cat <<EndofMessage
set terminal png
set output 'tp.png'
set key right bottom
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set xlabel "Key Size"
set ylabel "Time waiting for Memcached [ms]"
set title  "Time waiting for Memcached per Key Size"
set xrange [0:10] 
set yrange [0:2]
plot "TPMG_data.txt" using 1:(\$2/1000000):(\$3/1000000):xticlabel(1) with errorlines title "Multi Get" ls 1, \
"TPS_data.txt" using 1:(\$2/1000000):(\$3/1000000):xticlabel(1) with errorlines title "Set" ls 2

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


tp
