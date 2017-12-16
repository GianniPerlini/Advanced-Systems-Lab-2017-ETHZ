set terminal png
set output 'th.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Throughput [GET] [ops/s]"
set title  "Throughput per Number of Clients"
set xrange [0:72] 
set yrange [0:6000]
plot "GTH_wt8_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "MW with 8 Workers" ls 1, "GTH_wt16_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "MW with 16 Workers" ls 2, "GTH_wt32_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "MW with 32 Workers" ls 3, "GTH_wt64_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "MW with 64 Workers" ls 4

