#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function rt_tot {
        (cat <<EndofMessage
set terminal png
set key top left
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc "black" lt "dashed" lw 1 pt 7 ps 1
set output 'bl_set_rt_tot.png'
set xlabel "Number of Clients"
set ylabel "Response Time [SET] [ms]"
set title  "Response Time per Number of Clients"
set xrange [0:200]
set yrange [0:100]
plot "bl_set_tot.txt" using 1:4:5:xticlabel(1) with errorlines title "Experimental Data" ls 1, \
"bl_set_tot.txt" using 1:(\$1/\$2*1000):xticlabel(1) with linespoints title "Interactive Law" ls 2

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

function th_tot {
        (cat <<EndofMessage
set terminal png
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc "black" lt "dashed" lw 1 pt 7 ps 1
set output 'bl_set_th_tot.png'
set xlabel "Number of Clients"
set ylabel "Throughput [SET] [ops/s]"
set title  "Throughput per Number of Clients"
set xrange [0:200]
set yrange [0:3000]
plot "bl_set_tot.txt" using 1:2:3:xticlabel(1) with errorlines title "Experimental Data" ls 1, \
"bl_set_tot.txt" using 1:(\$1/\$4*1000):xticlabel(1) with linespoints title "Interactive Law" ls 2


EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

th_tot
rt_tot

