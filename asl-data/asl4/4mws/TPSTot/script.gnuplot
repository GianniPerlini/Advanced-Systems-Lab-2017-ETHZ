set terminal png
set output 'tps.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Time waiting Memcached [SET] [ms]"
set title  "Time waiting Memcached per Number of Clients"
set xrange [0:200] 
set yrange [0:5]
plot "TPS_wt8_data.txt" index 00:00 using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, "TPS_wt16_data.txt" index 00:00 using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, "TPS_wt32_data.txt" index 00:00 using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, "TPS_wt64_data.txt" index 00:00 using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

