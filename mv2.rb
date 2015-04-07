require 'curses'
include Curses

# I've had problems with window.move working in other programs.
# I've isolated the issue to the initial size of the window.
# I dont know how the original 

init_screen
stdscr

addstr("Enter the square dimensions for the window (i.e. 10, 20, etc)")
refresh
x = getstr.to_i
noecho
curs_set(0)
clear
refresh

field = Window.new(x,x,0,0)
viewp = field.subwin(x,x,0,0)
refresh

#control message
field.setpos(0,0)
field.addstr("Window: (#{field.begx},#{field.begy})")
field.refresh
getch
clear
refresh

#test move message
field.move(1,1)
field.setpos(0,0)
field.addstr("Window: (#{field.begx},#{field.begy})")
field.refresh
getch
clear
refresh

viewp.setpos(0,0)
viewp.addstr("Viewport Position = (#{viewp.begx},#{viewp.begy})")
viewp.refresh
getch
clear
refresh

viewp.move(1,1)
viewp.setpos(0,0)
viewp.addstr("Viewport Position = (#{viewp.begx},#{viewp.begy})")
viewp.refresh
getch