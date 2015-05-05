require 'ncurses'
include Ncurses

Ncurses.initscr
Ncurses.stdscr
Ncurses.curs_set(0)

y = []
x = []

Ncurses.getmaxyx(stdscr,y,x)

# Begin the color test.
Ncurses.start_color
Ncurses.init_pair(1,COLOR_BLUE,COLOR_WHITE)
Ncurses.move((y[0] - 5) / 2, (x[0] - 10) / 2)
Ncurses.addstr("Color Test")
Ncurses.refresh
Ncurses.getch


Ncurses.move((y[0] - 5) / 2, (x[0] - 10) / 2) 
#attron(color_pair(COLOR_RED)|A_NORMAL)
Ncurses.addstr("Can you believe these COLORS?!")
Ncurses.refresh
Ncurses.getch
Ncurses.clear

# Begin the corner test.
Ncurses.move((y[0] - 5) / 2, (x[0] - 10) / 2)
Ncurses.addstr("Corner Test")
Ncurses.refresh
Ncurses.getch

# Test putting numbers in corner with a delay between each number.
Ncurses.move(0,0)
Ncurses.addstr("*")
Ncurses.refresh

Ncurses.napms(1000)
Ncurses.move(0,(x[0] - 1))
Ncurses.addstr("*")
Ncurses.refresh

Ncurses.napms(1000)
Ncurses.move((y[0] - 1),0)
Ncurses.addstr("*")
Ncurses.refresh

Ncurses.napms(1000)
Ncurses.move((y[0] - 1),(x[0] - 1))
Ncurses.addstr("*")
Ncurses.refresh

Ncurses.move((y[0] - 5) / 2, (x[0] - 10) / 2)
Ncurses.addstr("Lines: #{y[0]}, Columns: #{x[0]}")
Ncurses.refresh
Ncurses.getch
Ncurses.clear

# New test for putting borders around the window
Ncurses.move((y[0] - 5) / 2, (x[0] - 10) / 2)
Ncurses.addstr("Border Test")
Ncurses.refresh
Ncurses.getch
Ncurses.clear

# Set North Border
Ncurses.move(0,0)
i = 0
while i < x[0] do
	Ncurses.addstr('-')
	i += 1
	Ncurses.move(0,i)
end
Ncurses.refresh

# Set West Border
Ncurses.move(1,0)
i = 0
while i < y[0] do
	Ncurses.addstr('|')
	i += 1
	Ncurses.move(i,0)
end
Ncurses.refresh

# Set East Border
Ncurses.move(1,(x[0] - 1))
i = 0
while i < y[0] do
	Ncurses.addstr('|')
	i += 1
	Ncurses.move(i,(x[0]-1))
end
Ncurses.refresh

# Set South Border
Ncurses.move((y[0] - 1),0)
i = 0
while i < x[0] do
	Ncurses.addstr('-')
	i += 1
	Ncurses.move((y[0] - 1),i)
end
Ncurses.refresh

# New test puts a message at the bottom of the screen
# Set bottom message Top Border
Ncurses.move((y[0] - 3),0)
i = 0
while i < x[0] do
	Ncurses.addstr('-')
	i += 1
	Ncurses.move((y[0] - 3),i)
end
Ncurses.refresh

# Set Message
Ncurses.move(y[0] - 2, (x[0] - 10) / 2)
Ncurses.addstr("***BOTTOM MESSAGE***")
Ncurses.refresh

Ncurses.move((y[0] - 5) / 2, (x[0] - 10) / 2)
Ncurses.addstr("Border Test Complete")
Ncurses.refresh
Ncurses.getch

# Clear screen and give a goodbye message.
Ncurses.clear
Ncurses.move((y[0] - 5) / 2, (x[0] - 10) / 2)
Ncurses.addstr("Goodbye!")
Ncurses.refresh
Ncurses.getch
Ncurses.clear # Removes characters, otherwise they're left on screen.
Ncurses.endwin # Turns of colors, releases memory