set terminal png
set output 'tsend.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Time to Send a Request [SET] [10th ms]"
set title  "Time to Send per Number of Clients"
set xrange [0:72] 
set yrange [0:3]
plot "TSendS_wt8_avg_data.txt" index 00:00 using 1:($2/100000):($3/100000):xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, "TSendS_wt16_avg_data.txt" index 00:00 using 1:($2/100000):($3/100000):xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, "TSendS_wt32_avg_data.txt" index 00:00 using 1:($2/100000):($3/100000):xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, "TSendS_wt64_avg_data.txt" index 00:00 using 1:($2/100000):($3/100000):xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

