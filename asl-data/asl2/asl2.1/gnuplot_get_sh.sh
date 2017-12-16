#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function rt_tot {
        (cat <<EndofMessage
set terminal png
set key top left
set key bottom right
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc "black" lt "dashed" lw 1 pt 7 ps 1
set style line 4 lc "grey" lt "dashed" lw 1 pt 7 ps 1
set output 'bl_get_rt_tot.png'
set xlabel "Number of Clients"
set ylabel "Response Time [ms]"
set title  "Response Time per Number of Clients"
set xrange [0:200]
set yrange [0:100]
plot "bl_get_tot.txt" using 1:4:5:xticlabel(1) with errorlines title "Get Response Time" ls 1, \
"bl_get_tot.txt" using 1:(\$1/\$2*1000):xticlabel(1) with linespoints title "Interactive Law Get" ls 3, \
"bl_set_tot.txt" using 1:4:5:xticlabel(1) with errorlines title "Set Response Time" ls 2, \
"bl_set_tot.txt" using 1:(\$1/\$2*1000):xticlabel(1) with linespoints title "Interactive Law Set" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

function th_tot {
        (cat <<EndofMessage
set terminal png
set output 'bl_get_th_tot.png'
set key bottom right
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc "black" lt "dashed" lw 1 pt 7 ps 1
set style line 4 lc "grey" lt "dashed" lw 1 pt 7 ps 1
set xlabel "Number of Clients"
set ylabel "Throughput [ops/s]"
set title  "Throughput per Number of Clients"
set xrange [0:200]
set yrange [0:3000]
plot "bl_get_tot.txt" using 1:2:3:xticlabel(1) with errorlines title "Get Throughput" ls 1, \
"bl_get_tot.txt" using 1:(\$1/\$4*1000):xticlabel(1) with linespoints title "Interactive Law Get" ls 3, \
"bl_set_tot.txt" using 1:2:3:xticlabel(1) with errorlines title "Set Throughput" ls 2, \
"bl_set_tot.txt" using 1:(\$1/\$4*1000):xticlabel(1) with linespoints title "Interactive Law Set" ls 4


EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

th_tot
rt_tot



