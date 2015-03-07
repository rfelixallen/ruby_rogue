require 'curses'
include Curses

# This is to test curses windows

init_screen

test_window = Window.new(20, 20, 20, 20)
test_window.box("*", "@")
winder = test_window.subwin(20, 20, 20, 20)
winder.setpos(2,3)
winder.addstr("Subwindow!")

winder.refresh
winder.getch
winder.close