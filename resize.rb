require 'curses'
include Curses

parent_x = 0
parent_y = 0
score_size = 3

init_screen
noecho
curs_set(0)

stdscr # initialize stdscr? Might be active by default

parent_y = stdscr.maxy # Gets y of terminal screen
parent_x = stdscr.maxx # Gets x of terminal screen
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

# Label the subwindows
field.setpos(1,1)
field.addstr("Field") 
score.setpos(1,1)
score.addstr("Score")
refresh

score.close # free up memory
refresh
getch
field.close # free up memory
refresh
getch