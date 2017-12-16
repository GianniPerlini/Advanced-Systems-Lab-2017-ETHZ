#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function ql {
        (cat <<EndofMessage
set terminal png
set output 'ql.png'
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set xlabel "Key Size"
set ylabel "Queue Length [Requests in Queue every 100ms]"
set title  "Queue Length per Key Size"
set xrange [0:10] 
set yrange [0:1]
plot "QL_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 1
EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

ql

