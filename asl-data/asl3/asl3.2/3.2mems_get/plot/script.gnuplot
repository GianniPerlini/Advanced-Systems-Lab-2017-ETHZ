set terminal png
set output 'rt_mem.png'
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Response Time on Memtier [GET] [ms]"
set title  "Response Time per Number of Clients"
set xrange [0:72] 
set yrange [0:15]
plot "mws_wt8_tot.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, "mws_wt16_tot.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, "mws_wt32_tot.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, "mws_wt64_tot.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

