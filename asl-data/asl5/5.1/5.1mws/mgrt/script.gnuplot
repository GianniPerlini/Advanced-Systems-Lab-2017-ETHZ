set terminal png
set output 'RTMG.png'
set key right bottom
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set xlabel "Key Size"
set ylabel "Response Time [ms]"
set title  "Response Time per Key Size"
set xrange [0:10] 
set yrange [0:3]
plot "RTMG_data.txt" using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "Multi Get" ls 1, "SRT_data.txt" using 1:($2/1000000):($3/1000000):xticlabel(1) with errorlines title "Set" ls 2

