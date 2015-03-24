require 'curses'
include Curses

def mvwprintw(window, y, x, symb)
	window.setpos(y,x)
	window.addch("#{symb}")
end

def borders(field)
	field.clear
	i = 0
	while i <= (lines - 1) do
		mvwprintw(field, i, 0, "|")
		mvwprintw(field, i, cols - 1, "|")
		i += 1
	end

	j = 0
	while j <= (cols - 1) do
		mvwprintw(field, 0, j, "+")
		mvwprintw(field, lines - 1, j, "+")
		j += 1
	end
	
	field.setpos(1,1)
	field.addstr("Field") 
	field.refresh
end

parent_x = 0
parent_y = 0

init_screen
noecho
curs_set(0)

stdscr # initialize stdscr? Might be active by default

parent_y = stdscr.maxy # Gets y of terminal screen
parent_x = stdscr.maxx # Gets x of terminal screen
field = stdscr.subwin(parent_y, parent_x, 0, 0)
borders(field)
field.setpos(lines / 2, cols  / 2)
field.addstr("x = #{parent_x}, y = #{parent_y}")
refresh
getch

# Label the subwindows
=begin
field.setpos(1,1)
field.addstr("Field") 
field.setpos(lines / 2, cols / 2)
field.addstr("Subwinow and borders drawn!")
field.refresh
getch
=end

while 1
	new_y = stdscr.maxy
	new_x = stdscr.maxx

	if (new_y != parent_y || new_x != parent_x)
		field.clear

		parent_x = new_x
		parent_y = new_y

		field.resize(new_y, new_x)
		borders(field)
		field.setpos(lines / 2, cols  / 2)
		field.addstr("x = #{parent_x}, y = #{parent_y}")
		field.refresh
	end
	field.refresh
end

field.close # free up memory
refresh
getch