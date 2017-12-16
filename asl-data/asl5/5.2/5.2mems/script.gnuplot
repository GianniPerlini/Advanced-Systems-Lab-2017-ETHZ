set terminal png
set output '5.2rt_mems.png'
set key left top
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 1.5
set style line 2 lc rgb '#60ad00' lt 1 lw 2 pt 7 ps 1.5
set xlabel "Key Size"
set ylabel "Response Time [ms]"
set title  "Response Time per Key Size"
set xrange [0:10] 
set yrange [0:5]
plot "5.2mems_rt.txt" index 00:00 using 1:2:3:xticlabel(1) with errorlines title "Set" ls 2, "5.2mems_rt.txt" index 00:00 using 1:4:5:xticlabel(1) with errorlines title "Multi Get" ls 1

