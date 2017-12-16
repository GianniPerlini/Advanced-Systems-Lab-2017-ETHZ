#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function tsend {
        (cat <<EndofMessage
set terminal png
set output 'tsend.png'
set key bottom right
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Time to Send a Request [SET] [10th ms]"
set title  "Time to Send per Number of Clients"
set xrange [0:72] 
set yrange [0:4]
plot "TSendS_wt8_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "MW with 8 Workers" ls 1, \
"TSendS_wt16_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "MW with 16 Workers" ls 2, \
"TSendS_wt32_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "MW with 32 Workers" ls 3, \
"TSendS_wt64_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "MW with 64 Workers" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


function tSend {
    echo "=========== Time to Send Plot ============"
    echo "This function plots the Time to Send a Request "
    echo "for SET operations with respect to"
    echo "the Number of Clients"
    echo "==========================================="
    tsend

}

tsend

