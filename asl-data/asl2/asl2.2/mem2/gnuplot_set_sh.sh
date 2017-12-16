#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function gnuplot_th {
        (cat <<EndofMessage
set terminal png
set key top left
set output 'bl1_set_th.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set xlabel "Number of Clients"
set ylabel "Throughput [SET] [ops/s]"
set title  "Throughput per Number of Clients"
set xrange [0:36] 
set yrange [0:3500]
plot "bl1_set_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Repetition 1" ls 1, \
"bl2_set_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Repetition 2" ls 2, \
"bl3_set_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Repetition 3" ls 3

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


function gnuplot_rt {
        (cat <<EndofMessage
set terminal png
set key top left
set output 'bl1_set_rt.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc "black" lt "dashed" pt 1 ps 1.5
set xlabel "Number of Clients"
set ylabel "Response Time [SET] [ms]"
set title  "Response Time per Number of Clients"
set xrange [0:36] 
set yrange [0:30]
plot "bl1_set_data.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Repetition 1" ls 1, \
"bl2_set_data.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Repetition 2" ls 2, \
"bl3_set_data.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Repetition 3" ls 3
EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


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
set xrange [0:36]
set yrange [0:30]
plot "bl_set_tot_3_rep.txt" using 1:4:5:xticlabel(1) with errorlines title "Experimental Data" ls 1, \
"bl_set_tot_3_rep.txt" using 1:(\$1/\$2*1000):xticlabel(1) with linespoints title "Interactive Law" ls 2

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

function th_tot {
        (cat <<EndofMessage
set terminal png
set key top left
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc "black" lt "dashed" lw 1 pt 7 ps 1
set output 'bl_set_th_tot.png'
set xlabel "Number of Clients"
set ylabel "Throughput [SET] [ops/s]"
set title  "Throughput per Number of Clients"
set xrange [0:36]
set yrange [0:3500]
plot "bl_set_tot_3_rep.txt" using 1:2:3:xticlabel(1) with errorlines title "Experimental Data" ls 1, \
"bl_set_tot_3_rep.txt" using 1:(\$1/\$4*1000):xticlabel(1) with linespoints title "Interactive Law" ls 2

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


th_tot
rt_tot
gnuplot_th
gnuplot_rt

