require 'curses'
include Curses

def refreshx(field,score)
	stdscr.refresh
	field.refresh
	score.refresh
end

def clearx(field,score)
	stdscr.clear
	field.clear
	score.clear
end

def borders(field,score,score_size)

	# Set West Border
	field.setpos(1,0)
	i = 1
	while i < lines - score_size do
		field.addch('|')
		i += 1
		field.setpos(i,0)
	end
	field.refresh
	getch

	# Set East Border
	field.setpos(1,(cols - 1))
	i = 1
	while i < lines - score_size do
		field.addch('|')
		i += 1
		field.setpos(i,(cols-1))
	end
	field.refresh
	getch

	# Set North Border
	field.setpos(0,0)
	i = 0
	while i < cols do
		field.addch('+')
		i += 1
		field.setpos(0,i)
	end
	field.refresh
	getch

	# Set South Border
	field.setpos((lines - 1),0)
	i = 0
	while i < cols do
		field.addch('+')
		i += 1
		field.setpos((lines - 1),i)
	end
	field.refresh
	getch
#####################################################
	# Set North Border
	score.setpos(score_size,0)
	i = 0
	while i < cols do
		score.addch('+')
		i += 1
		score.setpos(score_size,i)
	end
	score.refresh
	getch

	# Set South Border
	score.setpos(lines,0)
	i = 0
	while i < cols do
		score.addch('+')
		i += 1
		score.setpos(lines,i)
	end
	score.refresh
	getch

	# Set West Border
	score.setpos(1,0)
	i = 1
	while i < lines do
		score.addch('|')
		i += 1
		score.setpos(i,0)
	end
	score.refresh
	getch

	# Set East Border
	score.setpos(1, cols - 1)
	i = 1
	while i < lines  do
		score.addch('|')
		i += 1
		score.setpos(i,(cols - 1))
	end
	score.refresh
	getch
end

parent_x = 0
parent_y = 0
score_size = 3

init_screen
noecho
curs_set(0)

stdscr # initialize stdscr? Might be active by default

parent_y = stdscr.maxy # Gets y of terminal screen
parent_x = stdscr.maxx # Gets x of terminal screen
setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Current Terminal Window: x = #{parent_x}, y = #{parent_y}")
refresh
getch
clear

field = stdscr.subwin(parent_y - score_size, parent_x, 0, 0)
score = stdscr.subwin(score_size, parent_x, parent_y - score_size, 0)
#field.box("|", "-") #box doesnt resize well
#score.box("|", "-")
borders(field,score,score_size)
refresh
getch

# Label the subwindows
field.setpos(1,1)
field.addstr("Field") 
score.setpos(1,1)
score.addstr("Score")
field.setpos((lines - 5) / 2, (cols - 10) / 2)
field.addstr("x = #{parent_x}, y = #{parent_y}")
refreshx(field,score)
getch

while 1
	new_y = stdscr.maxy
	new_x = stdscr.maxx

	if (new_y != parent_y || new_x != parent_x)
		clearx(field,score)

		parent_x = new_x
		parent_y = new_y

		field.resize(new_y - score_size, new_x)
		score.resize(score_size, new_x)
		score.move(new_y - score_size, 0)

		field.setpos((lines - 5) / 2, (cols - 10) / 2)
		field.addstr("x = #{parent_x}, y = #{parent_y}")
		borders(field,score,score_size)
		refreshx(field,score)
	end
	refreshx(field,score)
end

score.close # free up memory
refresh
getch
field.close # free up memory
refresh
getch