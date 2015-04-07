require 'curses'
include Curses

init_screen
noecho
curs_set(0)
stdscr

window = Window.new(20,20,0,0)
subwindow = window.subwin(20, 20, 0, 0)
refresh
window.setpos(0,0)
window.addstr("Window: (#{window.begx},#{window.begy})")
window.refresh
getch
clear
refresh

window.move(2,2)
window.setpos(0,0)
window.addstr("Window: (#{window.begx},#{window.begy})")
window.refresh
getch
window.clear
window.refresh

subwindow.setpos(0,0)
subwindow.addstr("Sub: (#{subwindow.begx},#{subwindow.begy})")
subwindow.refresh
getch
clear
refresh

subwindow.move(2,2)
subwindow.setpos(0,0)
subwindow.addstr("Sub: (#{subwindow.begx},#{subwindow.begy})")
subwindow.refresh
getch