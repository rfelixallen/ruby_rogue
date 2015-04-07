require 'curses'
include Curses

init_screen
noecho
curs_set(0)
stdscr

field = Window.new(20,20,0,0)
viewp = field.subwin(20,20,0,0)
refresh

field.setpos(0,0)
field.addstr("Window: (#{field.begx},#{field.begy})")
field.refresh
getch
clear
refresh

viewp.move(3,3)
viewp.setpos(0,0)
viewp.addstr("Viewport Position = (#{viewp.begx},#{viewp.begy})")
viewp.refresh
getch