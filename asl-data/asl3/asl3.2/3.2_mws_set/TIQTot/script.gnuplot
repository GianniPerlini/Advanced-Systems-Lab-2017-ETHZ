set terminal png
set output 'tiq.png'
set key top left
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Time In Queue [SET] [ms]"
set title  "Time In Queue per Number of Clients"
set xrange [0:72] 
set yrange [0:4]
plot "TIQ_set_wt8_avg_data.txt" index 00:00 using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, "TIQ_set_wt16_avg_data.txt" index 00:00 using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, "TIQ_set_wt32_avg_data.txt" index 00:00 using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, "TIQ_set_wt64_avg_data.txt" index 00:00 using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

