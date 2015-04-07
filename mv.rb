require 'curses'
include Curses

init_screen
noecho
curs_set(0)
stdscr

window = Window.new(10,10,0,0)
refresh
window.setpos(0,0)
window.addstr("(#{window.begx},#{window.begy})")
window.refresh
getch
clear
refresh

window.move(2,2)
window.setpos(0,0)
window.addstr("(#{window.begx},#{window.begy})")
window.refresh
getch