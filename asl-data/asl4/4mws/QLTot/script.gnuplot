set terminal png
set output 'ql.png'
set key top left
set style line 1 lc 1 lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc 2 lt 1 lw 2 pt 7 ps 1.5
set style line 3 lc 3 lt 1 lw 2 pt 8 ps 1.5
set style line 4 lc 4 lt 1 lw 2 pt 10 ps 1.5
set xlabel "Number of Clients"
set ylabel "Queue Length [SET] [Requests in Queue every 100ms]"
set title  "Queue Length per Number of Clients"
set xrange [0:200] 
set yrange [0:160]
plot "QL_wt8_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 8 Workers each" ls 1, "QL_wt16_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 16 Workers each" ls 2, "QL_wt32_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 32 Workers each" ls 3, "QL_wt64_data.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 4

