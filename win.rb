require 'curses'
include Curses

# This is to test curses windows
# Discovered that the size of the window is dependant on the terminal, and might fail if the terminal isnt the correct length.

init_screen

test_window = Window.new(20, 20, (lines - 10) / 2, (cols - 10) / 2)
test_window.box("*", "@")
test_window.refresh
getch
winder = test_window.subwin(20, 20, (lines - 10) / 2, (cols - 10) / 2)
winder.setpos(2,3)
winder.addstr("Subwindow!")
winder.refresh
winder.getch
winder.close
clear

=begin
world = Window.new(100, 100, 100, 100)
world.box("|", "-")
viewport = world.subwin(5, 5, (lines - 5) / 2, (cols - 10) / 2)

viewport.refresh
viewport.getch
=end