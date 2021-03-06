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

def borders(window)
	#window.clear
	i = 0
	while i <= (lines - 1) do
		mvwprintw(window, i, 0, "|")
		mvwprintw(window, i, cols - 1, "|")
		i += 1
	end

	j = 0
	while j <= (cols - 1) do
		mvwprintw(window, 0, j, "+")
		mvwprintw(window, lines - 1, j, "+")
		j += 1
	end
	window.refresh
end

def simple_generate(window)
	i = 1
	max_x = window.maxx
	max_y = window.maxy
	while i < max_y - 1
		j = 1
		while j < max_x - 1
			mvwprintw(window, i, j, "~")
			#window.refresh
			j += 1
		end
		i += 1
	end
end

def center(subwin,parent,px,py)
	rr = subwin.begx 	#Frame Positions
	cc = subwin.begy 	#Frame Positions
	hh = parent.maxx	#Frame Dimensions		# get parent max y	
	ww = parent.maxy	#Frame Dimensions		# get parent max x
	height = subwin.maxy
	width = subwin.maxx
	r = px - (parent.maxx / 2)	# get player x and subtract it from the half point of window
	c = py - (parent.maxy / 2)		# get player y and subtract it from the half point of window			

	colls = c + width
	rowss = r + height

	if colls >= ww
		delta = ww - (c + width)
		cc = c + delta
	else
		cc = c
	end

	if rowss >= hh
		delta = hh - (r + height)
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

	subwin.move(rr,cc) # mvderwin is the correct method
end

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
clear
refresh

# Make Game Map
parent_x = stdscr.maxx # Gets x of terminal screen
parent_y = stdscr.maxy # Gets y of terminal screen
field = Window.new(100, 100, 0, 0)
viewp = field.subwin(39, 39, 0, 0)

# Draw borders, terrain and player
borders(viewp)
simple_generate(field)
fx = field.maxx
fy = field.maxy
p = Character.new((fy / 4), (fx / 4))
mvwprintw(field, p.px, p.py, "#{p.symb}")
viewp.refresh

#################################################################################
# Game Loop 																 	#
#################################################################################

while 1
=begin	
	# Resize window to the terminal screen
	new_y = stdscr.maxy
	new_x = stdscr.maxx

	if (new_y != parent_y || new_x != parent_x)
		viewp.clear

		parent_x = new_x
		parent_y = new_y

		viewp.resize(new_y, new_x) # Resizes window to terminal screen
		borders(viewp) # Redraw new borders
		simple_generate(field) # Put snow back on map
		viewp.refresh
		mvwprintw(field, p.px, p.py, "#{p.symb}")
		field.refresh
	end
=end
	viewp.setpos(1,1)
	viewp.addstr("Screen lines = #{parent_x}, Screen cols = #{parent_y}")
	viewp.setpos(2,1)
	viewp.addstr("Player lines = #{p.px}, Player cols = #{p.py}")
	viewp.setpos(3,1)
	viewp.addstr("Viewport Position = (#{viewp.begx},#{viewp.begy})")
	viewp.refresh
	input = getch
	case input
    when 'w' # move up
    	p.px -= 1 if p.px > 1
	    	mvwprintw(field, p.px + 1, p.py, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	viewp.refresh
    when 's' # move down
    	p.px += 1 if p.px < (field.maxy - 2)
	    	mvwprintw(field, p.px - 1, p.py, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	viewp.refresh
    when 'd' # move right
    	p.py += 1 if p.py < (field.maxx - 2)
	    	mvwprintw(field, p.px, p.py - 1, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	viewp.refresh
	when 'a' # move left
    	p.py -= 1 if p.py > 1
	    	mvwprintw(field, p.px, p.py + 1, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	viewp.refresh
    when 'q' # Quit Game
    	break
    when 'm' #move screen, tests the move method
    	viewp.move(15,15)
    	beep
    else
    	flash
    	viewp.refresh
    end
end

field.clear
field.setpos(lines / 2, cols  / 2)
field.addstr("Good Bye!")
field.refresh
field.close # free up memory
refresh
getch