#cat graphic.ptl |gnuplot
set terminal png size 800, 600 
set output 'graphic.png'
set ylabel "Время (мс)"
set xlabel "Размер массива"
set yrange [0:5]
set mytics (5) 
set grid xtics ytics mytics
set label "(1)" at 14000,4.2;
set label "(2)" at 14000,2.8;
plot 'graphic.log' u 1:2  w linesp  lw 2  title "(1) Сортировка Бинарным деревом", 'graphic.log' u 1:3 w  linesp lw 2  title "(2) Быстрая сортировка Хоара"


