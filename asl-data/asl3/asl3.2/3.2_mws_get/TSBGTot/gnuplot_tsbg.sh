#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function tsbs {
        (cat <<EndofMessage
set terminal png
set output 'tsbs.png'
set key bottom right
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Time to Send Response to Client [GET] [10th ms]"
set title  "Time to Send Response per Number of Clients"
set xrange [0:72] 
set yrange [0:7]
plot "TSBG_wt8_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, \
"TSBG_wt16_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, \
"TSBG_wt32_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, \
"TSBG_wt64_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


function tSBS {
    echo "=========== Time to Send Response Plot ============"
    echo "This function plots the Time to Send Response to Client "
    echo "for GET operations with respect to"
    echo "the Number of Clients"
    echo "==========================================="
    tsbs

}

tSBS

