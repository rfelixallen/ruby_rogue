require 'curses'
include Curses

# I've had problems with window.move working in other programs.
# I've isolated the issue to the initial size of the window.
# I dont know how the original 

# Update: Problem seems to be with the terminal size. Specifying the size is better.

def test_window_move(i)
	n = i
	i.times do
		field = Window.new(n,n,0,0)
		viewp = field.subwin(n,n,0,0)
		refresh
		
		#control message
		field.setpos(0,0)
		field.addstr("Field #{n}: (#{field.begx},#{field.begy})")
		field.refresh
		getch
		clear
		refresh

		#test move message
		field.move(1,1)
		field.setpos(0,0)
		field.addstr("Field move #{n}: (#{field.begx},#{field.begy})")
		field.refresh
		getch
		clear
		refresh

		viewp.setpos(0,0)
		viewp.addstr("Viewp #{n}: (#{viewp.begx},#{viewp.begy})")
		viewp.refresh
		getch
		clear
		refresh

		viewp.move(1,1)
		viewp.setpos(0,0)
		viewp.addstr("Viewp move #{n}: (#{viewp.begx},#{viewp.begy})")
		viewp.refresh
		getch
		clear
		refresh

		viewp.close
		field.close
		n += 1
	end
end

init_screen
stdscr

addstr("Enter the square dimensions for the window (i.e. 10, 20, etc)")
refresh

x = getstr.to_i		#Dimensions that work: 10,20,30,40

noecho
curs_set(0)
clear
refresh

test_window_move(x)

=begin
px = stdscr.maxx
py = stdscr.maxy
#term = Window.new(py,px,0,0)
#subterm = term.subwin(py,px,0,0)
#control message
field.setpos(0,0)
field.addstr("Field: (#{field.begx},#{field.begy})")
field.refresh
getch
clear
refresh

#test move message
field.move(1,1)
field.setpos(0,0)
field.addstr("Field move: (#{field.begx},#{field.begy})")
field.refresh
getch
clear
refresh

viewp.setpos(0,0)
viewp.addstr("Viewp: (#{viewp.begx},#{viewp.begy})")
viewp.refresh
getch
clear
refresh

viewp.move(1,1)
viewp.setpos(0,0)
viewp.addstr("Viewp move: (#{viewp.begx},#{viewp.begy})")
viewp.refresh
getch
clear
refresh

#control message
term.setpos(0,0)
term.addstr("Terminal: (#{term.begx},#{term.begy})")
term.refresh
getch
clear
refresh

#test move message
term.move(1,1)
term.setpos(0,0)
term.addstr("Terminal move: (#{term.begx},#{term.begy})")
term.refresh
getch
clear
refresh

subterm.setpos(0,0)
subterm.addstr("Subterm: (#{subterm.begx},#{subterm.begy})")
subterm.refresh
getch
clear
refresh

subterm.move(1,1)
subterm.setpos(0,0)
subterm.addstr("Subterm move: (#{subterm.begx},#{subterm.begy})")
subterm.refresh
getch
=end