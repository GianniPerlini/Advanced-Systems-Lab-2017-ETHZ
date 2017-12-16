#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function gnuplot_th {
        (cat <<EndofMessage
set terminal png
set key top left
set output 'bl1_get_th.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set xlabel "Number of Clients"
set ylabel "Throughput [GET ops] [ops/s]"
set title  "Throughput per Number of Clients"
set xrange [0:36] 
set yrange [0:3500]
plot "bl1_get_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Repetition 1" ls 1, \
"bl2_get_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Repetition 2" ls 2, \
"bl3_get_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Repetition 3" ls 3

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


function gnuplot_rt {
        (cat <<EndofMessage
set terminal png
set key top left
set output 'bl1_get_rt.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set xlabel "Number of Clients"
set ylabel "Response Time [GET] [ms]"
set title  "Response Time per Number of Clients"
set xrange [0:36] 
set yrange [0:30]
plot "bl1_get_data.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Repetition 1" ls 1, \
"bl2_get_data.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Repetition 2" ls 2, \
"bl3_get_data.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Repetition 3" ls 3

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

function rt {
        (cat <<EndofMessage
set terminal png
set key bottom right
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc "black" lt "dashed" lw 1 pt 7 ps 1
set style line 4 lc "grey" lt "dashed" lw 1 pt 7 ps 1
set output '2-2_c2_rt.png'
set xlabel "Number of Clients"
set ylabel "Response Time [ms]"
set title  "Response Time per Number of Clients"
set xrange [0:36]
set yrange [0:20]
plot "bl_get_tot_3_rep.txt" using 1:4:5:xticlabel(1) with errorlines title "Response Time Get" ls 1, \
"bl_get_tot_3_rep.txt" using 1:(\$1/\$2*1000):xticlabel(1) with linespoints title "Interactive Law Get" ls 3, \
"bl_set_tot_3_rep.txt" using 1:4:5:xticlabel(1) with errorlines title "Response Time Set" ls 2, \
"bl_set_tot_3_rep.txt" using 1:(\$1/\$2*1000):xticlabel(1) with linespoints title "Interactive Law Set" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

function th {
        (cat <<EndofMessage
set terminal png
set key bottom right
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc "black" lt "dashed" lw 1 pt 7 ps 1
set style line 4 lc "grey" lt "dashed" lw 1 pt 7 ps 1
set output '2-2_c2_th.png'
set xlabel "Number of Clients"
set ylabel "Throughput [ops/s]"
set title  "Throughput per Number of Clients"
set xrange [0:36]
set yrange [0:3500]
plot "bl_get_tot_3_rep.txt" using 1:2:3:xticlabel(1) with errorlines title "Get Throughput" ls 1, \
"bl_get_tot_3_rep.txt" using 1:(\$1/\$4*1000):xticlabel(1) with linespoints title "Interactive Law Get" ls 3, \
"bl_set_tot_3_rep.txt" using 1:2:3:xticlabel(1) with errorlines title "Set Throughput" ls 2, \
"bl_set_tot_3_rep.txt" using 1:(\$1/\$4*1000):xticlabel(1) with linespoints title "Interactive Law Set" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


th
rt
