#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function th {
        (cat <<EndofMessage
set terminal png
set output 'tht.png'
set key right bottom
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc rgb '#39CCCC' lt 1 lw 2 pt 9 ps 1.5
set style line 4 lc rgb '#FF851B' lt 1 lw 2 pt 3 ps 1.5
set xlabel "Key Size"
set ylabel "Throughput and Arrival Rate [ops/s]"
set title  "Throughput and Arrival Rate per Key Size"
set xrange [0:10]
set yrange [0:5000]
plot "MGTH_data.txt" using 1:2:3:xticlabel(1) with errorlines title "Multi Get" ls 1, \
"STH_data.txt" using 1:2:3:xticlabel(1) with errorlines title "Set" ls 2, \
"TH_data.txt" using 1:2:3:xticlabel(1) with errorlines title "Total Throughput" ls 3, \
"AR_data.txt" using 1:2:3:xticlabel(1) with errorlines title "Arrival Rate" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

th
