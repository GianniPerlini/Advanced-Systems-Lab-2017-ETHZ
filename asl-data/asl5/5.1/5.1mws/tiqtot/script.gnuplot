set terminal png
set output 'tiq.png'
set key right bottom
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set xlabel "Key Size"
set ylabel "Time in Queue [10th ms]"
set title  "Time Spent in Queue per Key Size"
set xrange [0:10] 
set yrange [0:2.5]
plot "TIQG_data.txt" using 1:($2/100000):($3/100000):xticlabel(1) with errorlines title "Multi Get" ls 1, "TIQS_data.txt" using 1:($2/100000):($3/100000):xticlabel(1) with errorlines title "Set" ls 2

