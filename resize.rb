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

def mvwprintw(window, y, x, symb)
	window.setpos(y,x)
	window.addch("#{symb}")
end

def borders(field,score,score_size)
	i = 0
	while i < (lines - 1) do
		mvwprintw(field, i, 0, "|")
		mvwprintw(field, i, cols - 1, "|")
		mvwprintw(score, i, 0, "|")
		mvwprintw(score, i, cols - 1, "|")
		i += 1
	end
	refreshx(field,score)
	#getch

	i = 0
	while i <= cols - 1 do
		mvwprintw(field, 0, i, "+")
		mvwprintw(field, lines - 1, i, "+")
		mvwprintw(score, 0, i, "+")
		mvwprintw(score, score_size - 1, i, "+")
		i += 1
	end
	refreshx(field,score)
	#getch
=begin
	i = 0
	while i < (lines - 1) do
		mvwprintw(score, i, 0, "|")
		mvwprintw(score, i, cols - 1, "|")
		i += 1
	end
	score.refresh
	#getch

	i = 0
	while i <= cols - 1 do
		mvwprintw(score, 0, i, "+")
		mvwprintw(score, score_size - 1, i, "+")
		i += 1
	end
	score.refresh
=end
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
		field.setpos(1,1)
		field.addstr("Field") 
		score.setpos(1,1)
		score.addstr("Score")
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