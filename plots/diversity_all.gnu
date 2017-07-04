#!/usr/bin/gnuplot
#
# Colored tics with the epslatex terminal
#
# AUTHOR: Hagen Wierstorf

reset

# epslatex
#set terminal epslatex size 10.4cm,6.35cm color colortext standalone 'phv,9' \
#header '\definecolor{t}{rgb}{0.5,0.5,0.5}'
#set output 'epslatex_correct.tex'
# wxt
#set terminal wxt size 410,250 enhanced font 'Verdana,9' persist
# png
#set terminal pngcairo size 1600,600 enhanced font 'Verdana,9'
set terminal pngcairo size 650,300 enhanced dashed font 'Verdana,10'
set terminal pngcairo size 1650,300 enhanced dashed font 'Verdana,10'
set output 'diversity.png'
# svg
#set terminal svg size 410,250 fname 'Verdana, Helvetica, Arial, sans-serif' fsize '9' rounded dashed
#set output 'nice_web_plot.svg'

# define axis
# remove border on top and right and set color to gray
set style line 11 lc rgb '#808080' lt 1
set border 3 front ls 11
set tics nomirror
# define grid
set style line 12 lc rgb'#808080' lt 0 lw 1
set grid back ls 12

#show style lines

# color definitions
#set style line 1 lc rgb '#000000' pt 1 ps 1.5 lw 1
#set style line 2 lc rgb '#000000' pt 2 ps 1.5 lw 1
#set style line 3 lc rgb '#000000' pt 3 ps 1.5 lw 1
#set style line 4 lc rgb '#000000' pt 4 ps 1.5 lw 1
#set style line 5 lc rgb '#000000' pt 8 ps 1.5 lw 1
#set style line 6 lc rgb '#000000' pt 6 ps 1.5 lw 1

set style line 1 lw 1 lt 1 lc rgb '#1B9E77' # dark teal
set style line 2 lw 1 lt 1 lc rgb '#D95F02' # dark orange
set style line 3 lw 1 lt 1 lc rgb '#7570B3' # dark lilac
set style line 4 lw 1 lt 1 lc rgb '#E7298A' # dark magenta
set style line 5 lw 1 lt 1 lc rgb '#66A61E' # dark lime green
set style line 6 lw 1 lt 1 lc rgb '#E6AB02' # dark banana
set style line 7 lw 1 lt 1 lc rgb '#A6761D' # dark tan
set style line 8 lw 1 lt 1 lc rgb '#666666' # dark gray

set key top right

set key samplen 4

#set format '$'
set xlabel 'Geração'
set ylabel 'Diversidade'

set xrange [0:]
set yrange [0:]
set xtics rotate by -55
#set format y "%.0s*10^%T"
#set format y "%.0tx10^%1T"

plot \
'log'      u (column(0)):4 t 'Diversity'  w l ls 1, \
'log2'     u (column(0)):4 t 'Diversity2' w l ls 2, \
'log3'     u (column(0)):4 t 'Diversity3' w l ls 3
