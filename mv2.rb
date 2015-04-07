require 'curses'
include Curses

init_screen
noecho
curs_set(0)
stdscr # initialize stdscr? Might be active by default

field = Window.new(100,100,0,0)
viewp = field.subwin(50, 50, 1, 1)
refresh
viewp.move(3,3)
viewp.addstr("Viewport Position = (#{viewp.begx},#{viewp.begy})")
viewp.refresh
getch