require 'curses'
include Curses
##################################################################################
# TODO																			 #
# Center viewport on the character, and make the window bigger than the viewport.#
# 																				 #
##################################################################################
# Class & Methods																 #
##################################################################################
class Character
	attr_accessor :px, :py, :symb
	def initialize(px, py)
		@symb = '@'
		@px = px 
		@py = py
	end
end

def mvwprintw(window, x, y, symb)
	window.setpos(x,y)
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

def simple_generate(window)
	i = 1
	max_x = window.maxx
	max_y = window.maxy
	while i < max_y - 1
		j = 1
		while j < max_x - 1
			mvwprintw(window, i, j, "~")
			window.refresh
			j += 1
		end
		i += 1
	end
end

=begin
def center(subwin,px,py,max_lines,max_cols)
	# Get player x,y 
	# Calculate player x,y as center of viewport
	# player updates move in world. world shifts in viewport
	# Set r,c to be the top left corner of the window
	# Set move(r,c)
	r = px - (max_lines / 2)	# get player x and subtract it from the half point of window
	c = py - (max_cols / 2)		# get player y and subtract it from the half point of window
	h = subwin.maxx				# get current subwindow max x
	w = subwin.maxy				# get current subwindow max y

	# if c is greater than max_cols
	if c + w >= max_cols
		delta = max_cols - (c + w)
		cc = c + delta
	else
		cc = c
	end
	if r + h >= max_lines
		delta = max_lines - (r + h)
		rr = r + delta
	else
		rr = r
	end
	if r < 0
		rr = 0
	end
	if c < 0
		cc = 0
	end

	subwin.move(r, c)
end
=end

#################################################################################
# Initialize 																 	#
#################################################################################

init_screen
noecho
curs_set(0)
stdscr # initialize stdscr? Might be active by default

# Welcome Streen
setpos(lines / 2, cols  / 2)
addstr("Welcome to Move!")
setpos((lines / 2) + 1, cols  / 2)
addstr("x = #{stdscr.maxx}, y = #{stdscr.maxy}")
refresh
getch

# Make Game Map
parent_x = stdscr.maxx # Gets x of terminal screen
parent_y = stdscr.maxy # Gets y of terminal screen
field = stdscr.subwin(parent_y + 50, parent_x + 50, 0, 0)
viewp = field.subwin(parent_y, parent_x, 0, 0)

# Draw borders, terrain and player
borders(field)
simple_generate(field)
field.setpos(lines / 2, cols  / 2)
field.addstr("x = #{parent_x}, y = #{parent_y}")
field.setpos((lines / 2) + 1, cols  / 2)
field.addstr("map x = #{field.maxx}, map y = #{field.maxy}")

p = Character.new(3, 3)
mvwprintw(field, p.px, p.py, "#{p.symb}")
field.refresh

#################################################################################
# Game Loop 																 	#
#################################################################################

while 1
	# Resize window to the terminal screen
	new_y = stdscr.maxy
	new_x = stdscr.maxx

	if (new_y != parent_y || new_x != parent_x)
		field.clear

		parent_x = new_x
		parent_y = new_y

		field.resize(new_y, new_x) # Resizes window to terminal screen
		borders(field) # Redraw new borders
		simple_generate(field) # Put snow back on map
		field.setpos(lines / 2, cols  / 2)
		field.addstr("x = #{parent_x}, y = #{parent_y}")
		field.setpos((lines / 2) + 1, cols  / 2)
		field.addstr("map x = #{field.maxx}, map y = #{field.maxy}")
		field.refresh
		mvwprintw(field, p.px, p.py, "#{p.symb}")
		field.refresh
	end
	field.refresh

	input = getch
	case input
    when 'w' # move up
    	p.px -= 1 if p.px > 1
	    	mvwprintw(field, p.px + 1, p.py, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    	#center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
    	field.refresh
    when 's' # move down
    	p.px += 1 if p.px < (field.maxy - 2)
	    	mvwprintw(field, p.px - 1, p.py, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    	#center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
    	field.refresh
    when 'd' # move right
    	p.py += 1 if p.py < (field.maxx - 2)
	    	mvwprintw(field, p.px, p.py - 1, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    	#center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
    	field.refresh
	when 'a' # move left
    	p.py -= 1 if p.py > 1
	    	mvwprintw(field, p.px, p.py + 1, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    	#center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
    	field.refresh
    when 'q' # Quit Game
    	break
    else
    	flash
    	field.refresh
    end
end

field.clear
field.setpos(lines / 2, cols  / 2)
field.addstr("Good Bye!")
field.refresh
field.close # free up memory
refresh
getch