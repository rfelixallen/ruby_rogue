require 'curses'
include Curses

init_screen # Begin the standard screen.

# Begin the color test.
start_color
init_pair(1,COLOR_BLUE,COLOR_WHITE)
setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Color Test")
refresh
getch

setpos((lines - 5) / 2, (cols - 10) / 2) 
#attron(color_pair(COLOR_RED)|A_NORMAL)
addstr("Can you believe these COLORS?!")
refresh
getch
clear

# Begin the corner test.
setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Corner Test")
refresh
getch

# Test putting numbers in corner with a delay between each number.
setpos(0,0)
addch('1')
refresh

setpos(0,(cols - 1))
addch('2')
refresh

setpos((lines - 1),0)
addch('3')
refresh

setpos((lines - 1),(cols - 1))
addch('4')
refresh

setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Lines: #{lines}, Columns: #{cols}")
refresh
getch
clear

# New test for putting borders around the window
setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Border Test")
refresh
getch
clear

# Set North Border
setpos(0,0)
i = 0
while i < cols do
	addch('-')
	i += 1
	setpos(0,i)
end
refresh

# Set West Border
setpos(1,0)
i = 0
while i < lines do
	addch('|')
	i += 1
	setpos(i,0)
end
refresh

# Set East Border
setpos(1,(cols - 1))
i = 0
while i < lines do
	addch('|')
	i += 1
	setpos(i,(cols-1))
end
refresh

# Set South Border
setpos((lines - 1),0)
i = 0
while i < cols do
	addch('-')
	i += 1
	setpos((lines - 1),i)
end
refresh

# New test puts a message at the bottom of the screen
# Set bottom message Top Border
setpos((lines - 3),0)
i = 0
while i < cols do
	addch('-')
	i += 1
	setpos((lines - 3),i)
end
refresh

# Set Message
setpos(lines - 2, (cols - 10) / 2)
addstr("***BOTTOM MESSAGE***")
refresh

setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Border Test Complete")
refresh
getch
clear

# Clear screen and give a goodbye message.
clear
setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Goodbye!")
refresh
getch
close_screen