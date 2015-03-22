require 'curses'
include Curses

parent_x = 0
parent_y = 0
score_size = 3

init_screen
noecho
curs_set(0)

stdscr

parent_y = stdscr.maxy 
parent_x = stdscr.maxx
setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Current Terminal Window: x = #{parent_x}, y = #{parent_y}")
refresh
getch
clear

field = stdscr.subwin(parent_y - score_size, parent_x, 0, 0)
score = stdscr.subwin(score_size, parent_x, parent_y - score_size, 0)
field.box("|", "-")
score.box("|", "-")
refresh
getch