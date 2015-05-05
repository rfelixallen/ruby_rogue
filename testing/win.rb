# TODO
# Make subwindows to create different HUD screens.
#   i.e. main view, inventory, menu bar, etc
# Launch new main window in seperate terminal window

require 'curses'
include Curses

# This is to test curses windows
# Discovered that the size of the window is dependant on the terminal, and might fail if the terminal isnt the correct length.
# window + subwindow origins need to be similar I guess?

curs_set(0)	# Gets rid of blinking cursor.
init_screen
start_color
# Determines the colors in the 'attron' below
init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 
init_pair(COLOR_RED,COLOR_RED,COLOR_BLACK)
# Syntax for making windows
# win = Window.new(lines, cols, y_org, x_org)

# test_window = Window.new(20, 20, (lines - 10) / 2, (cols - 10) / 2)
test_window = Window.new(20, 20, 0, 0)
test_window.box("|", "-")
test_window.refresh
getch
# winder = test_window.subwin(20, 20, (lines - 10) / 2, (cols - 10) / 2)
winder = test_window.subwin(20, 20, 0, 0)
winder.setpos(2, 3)
winder.attron(color_pair(COLOR_BLUE)|A_NORMAL){
      winder.addstr("Subwindow!")
}
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