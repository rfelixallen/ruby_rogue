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

Ncurses.napms(5000)
Ncurses.move(0,(x[0] - 1))
Ncurses.addstr("*")
Ncurses.refresh

Ncurses.napms(5000)
Ncurses.move((y[0] - 1),0)
Ncurses.addstr("*")
Ncurses.refresh

Ncurses.napms(5000)
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

=begin

# Set North Border
move(0,0)
i = 0
while i < cols do
	addch('-')
	i += 1
	move(0,i)
end
refresh

# Set West Border
move(1,0)
i = 0
while i < lines do
	addch('|')
	i += 1
	move(i,0)
end
refresh

# Set East Border
move(1,(cols - 1))
i = 0
while i < lines do
	addch('|')
	i += 1
	move(i,(cols-1))
end
refresh

# Set South Border
move((lines - 1),0)
i = 0
while i < cols do
	addch('-')
	i += 1
	move((lines - 1),i)
end
refresh

# New test puts a message at the bottom of the screen
# Set bottom message Top Border
move((lines - 3),0)
i = 0
while i < cols do
	addch('-')
	i += 1
	move((lines - 3),i)
end
refresh

# Set Message
move(lines - 2, (cols - 10) / 2)
addstr("***BOTTOM MESSAGE***")
refresh

move((lines - 5) / 2, (cols - 10) / 2)
addstr("Border Test Complete")
refresh
getch
clear

# Clear screen and give a goodbye message.
clear
move((lines - 5) / 2, (cols - 10) / 2)
addstr("Goodbye!")
refresh
getch
close_screen
=end