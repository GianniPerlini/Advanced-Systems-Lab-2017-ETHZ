#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function aR {
        (cat <<EndofMessage
set terminal png
set output 'ar.png'
set key right bottom
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Arrival Rate [SET] [Arriving Request every second]"
set title  "Arrival Rate per Number of Clients"
set xrange [0:72] 
set yrange [0:6000]
plot "AR_set_wt8_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "MW with 8 Workers" ls 1, \
"AR_set_wt16_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "MW with 16 Workers" ls 2, \
"AR_set_wt32_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "MW with 32 Workers" ls 3, \
"AR_set_wt64_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "MW with 64 Workers" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}

function AR {
    echo "=========== Arrival Rate Plot ============"
    echo "This function plots the Arrival Rate "
    echo "for SET operations with respect to"
    echo "the Number of Clients"
    echo "==========================================="
    aR

}

AR

