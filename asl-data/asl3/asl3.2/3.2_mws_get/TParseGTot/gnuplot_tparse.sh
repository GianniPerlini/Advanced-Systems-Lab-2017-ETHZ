#!/bin/bash

gnu_script=script.gnuplot
gnuplot=gnuplot

function tparse {
        (cat <<EndofMessage
set terminal png
set output 'tparse.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Time to Parse a Request [GET] [10th ms]"
set title  "Time to Parse per Number of Clients"
set xrange [0:72] 
set yrange [0:10]
plot "TParseG_wt8_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, \
"TParseG_wt16_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, \
"TParseG_wt32_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, \
"TParseG_wt64_data.txt" index 00:00 using 1:(\$2/100000):(\$3/100000):xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

EndofMessage
)>$gnu_script
    $gnuplot $gnu_script
}


function tParse {
    echo "=========== Time to Parse Plot ============"
    echo "This function plots the Time to Parse a Request "
    echo "for GET operations with respect to"
    echo "the Number of Clients"
    echo "==========================================="
    tparse

}

tParse

