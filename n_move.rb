require 'ncurses'
include Ncurses

##################################################################################
# TODO																			 #
# Convert old curses library to new ncurses library.							 #
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
=begin
def mvwprintw(window, x, y, symb)
	window.move(x,y)
	window.addch("#{symb}")
end
=end
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

Ncurses.init_screen
Ncurses.noecho
Ncurses.curs_set(0)
Ncurses.stdscr # initialize stdscr? Might be active by default
sd_y = []
sd_x = []
Ncurses.getmaxyx(stdscr,sd_y,sd_x)

# Welcome Streen
Ncurses.move(sd_y[0] / 2, sd_x[0]  / 2)
Ncurses.addstr("Welcome to Move!")
Ncurses.move((sd_y[0] / 2) + 1, sd_x[0]  / 2)
Ncurses.addstr("rows = #{sd_y[0]}, rows = #{sd_x[0]}")
Ncurses.refresh
Ncurses.getch
Ncurses.clear
Ncurses.refresh

# Make Game Map
field = Ncurses.newwin(sd_y * 2, sd_x * 2, 0, 0)
viewp = Ncurses.subwin(field,sd_y, sd_x, 0, 0)

# Draw borders, terrain and player
#borders(viewp)
#simple_generate(field)
f_x = []
f_y = []
Ncurses.getmaxyx(field,f_y,f_x)
p = Character.new((fy / 4), (fx / 4))
Ncurses.mvwprintw(field, p.px, p.py, "#{p.symb}")
Ncurses.refresh(viewp)

#################################################################################
# Game Loop 																 	#
#################################################################################

while 1
=begin	
	# Resize window to the terminal screen
	new_y = stdscr.maxy
	new_x = stdscr.maxx

	if (new_y != parent_y || new_x != parent_x)
		Ncurses.wclear(viewp)

		parent_x = new_x
		parent_y = new_y

		viewp.resize(new_y, new_x) # Resizes window to terminal screen
		borders(viewp) # Redraw new borders
		simple_generate(field) # Put snow back on map
		Ncurses.refresh(viewp)
		mvwprintw(field, p.px, p.py, "#{p.symb}")
		Ncurses.refresh(field)
	end
=end
	Ncurses.wmove(viewp,1,1)
	viewp.addstr("Screen lines = #{parent_x}, Screen cols = #{parent_y}")
	Ncurses.wmove(viewp,2,1)
	viewp.addstr("Player lines = #{p.px}, Player cols = #{p.py}")
	Ncurses.wmove(viewp,3,1)
	viewp.addstr("Viewport Position = (#{viewp.begx},#{viewp.begy})")
	Ncurses.refresh(viewp)
	input = getch
	case input
    when 'w' # move up
    	p.px -= 1 if p.px > 1
	    	mvwprintw(field, p.px + 1, p.py, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.refresh(viewp)
    when 's' # move down
    	p.px += 1 if p.px < (field.maxy - 2)
	    	mvwprintw(field, p.px - 1, p.py, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.refresh(viewp)
    when 'd' # move right
    	p.py += 1 if p.py < (field.maxx - 2)
	    	mvwprintw(field, p.px, p.py - 1, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.refresh(viewp)
	when 'a' # move left
    	p.py -= 1 if p.py > 1
	    	mvwprintw(field, p.px, p.py + 1, "\"") # Looks like footprints
    		mvwprintw(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.refresh(viewp)
    when 'q' # Quit Game
    	break
    else
    	Ncurses.flash
    	Ncurses.refresh(viewp)
    end
end

Ncurses.wclear(field)
Ncurses.mvwaddstr(field, lines / 2, cols / 2, "Good Bye!")
Ncurses.refresh(field)
Ncurses.getch
Ncurses.endwin