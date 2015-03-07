require 'curses'
include Curses
init_screen
curs_set(0)	# Gets rid of blinking cursor.
start_color
init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 
player = '@'

win = Window.new(20,20,0,0)
win.box("|", "-")
win.refresh
getch

viewp = win.subwin(20, 20, 0, 0)
viewp.setpos(2, 3)
viewp.addstr("#{player}")
viewp.refresh
viewp.getch

win.close