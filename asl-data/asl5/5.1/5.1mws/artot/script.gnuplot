set terminal png
set output 'ar.png'
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set key right bottom
set xlabel "Key Size in Multi Get"
set ylabel "Arrival Rate [Arriving Request every second]"
set title  "Arrival Rate per Key Size"
set xrange [0:10] 
set yrange [0:5000]
plot "AR_data.txt" using 1:2:3:xticlabel(1) with errorlines title "2 MWs with 64 Workers each" ls 1

