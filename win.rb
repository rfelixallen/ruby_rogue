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


=begin
world = Window.new(100, 100, 100, 100)
world.box("|", "-")
viewport = world.subwin(5, 5, (lines - 5) / 2, (cols - 10) / 2)

viewport.refresh
viewport.getch
=end