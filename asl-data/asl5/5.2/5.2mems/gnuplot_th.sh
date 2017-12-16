#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function th {
        (cat <<EndofMessage
set terminal png
set output '5.2th_mems.png'
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc rgb '#39CCCC' lt 1 lw 2 pt 7 ps 1.5
set xlabel "Key Size"
set ylabel "Throughput [ops/s]"
set title  "Throughput per Key Size"
set xrange [0:10] 
set yrange [0:5000]
plot "5.2mems_th.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Multi Get" ls 1, \
"5.2mems_th.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Set" ls 2, \
"5.2mems_tot_th.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Total Throughput" ls 3

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


function rt {
        (cat <<EndofMessage
set terminal png
set output '5.2rt_mems.png'
set key left top
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set xlabel "Key Size"
set ylabel "Response Time [ms]"
set title  "Response Time per Key Size"
set xrange [0:10] 
set yrange [0:5]
plot "5.2mems_rt.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Set" ls 2, \
"5.2mems_rt.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Multi Get" ls 1

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


th
rt

