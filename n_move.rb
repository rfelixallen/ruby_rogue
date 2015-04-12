require 'ncurses'
include Ncurses

##################################################################################
# TODO																			 #							 #
# Fix centering.																 #
# Combine border + generate to be handled at the same time						 #
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
def add_player(window, orow, ocol, nrow, ncol, symb)
	if ((row_0 >= 0 && row_0 < height) && (col_0 >= 0 && col_0 < width))
		mvwaddstr(window, orow, ocol, ' ')
		mvwaddstr(window, nrow, ncol, symb)
end
=end

def draw_map(window)
	#window.clear
	i = 1
	w_y = []
	w_x = []
	Ncurses.getmaxyx(window,w_y,w_x)
	# Draw Borders
	while i <= (w_y[0] - 1) do
		Ncurses.mvwaddstr(window, i, 0, "|")
		Ncurses.mvwaddstr(window, i, w_x[0] - 1, "|")
		i += 1
	end

	j = 0
	while j <= (w_x[0] - 1) do
		Ncurses.mvwaddstr(window, 0, j, "+")
		Ncurses.mvwaddstr(window, w_y[0] - 1, j, "+")
		j += 1
	end

	# Draw Terrain
	i = 1
	while i < w_x[0] - 1
		j = 1
		while j < w_y[0] - 1
			Ncurses.mvwaddstr(window, i, j, "~")
			j += 1
		end
		i += 1
	end
end

def center(subwin,parent,px,py)
	rr = [] 	#Frame Positions
	cc = [] 	#Frame Positions
	Ncurses.getbegyx(subwin, rr, cc)

	hh = []		#Frame Dimensions
	ww = []		#Frame Dimensions
	Ncurses.getmaxyx(parent, hh, ww)

	height = []
	width = []
	Ncurses.getmaxyx(subwin, height, width)

	c = py - (hh[0] / 2)		# get player y and subtract it from the half point of window
	r = px - (ww[0] / 2)		# get player x and subtract it from the half point of window		

	if (c + width[0]) >= ww[0]
		delta = ww[0] - (c + width[0])
		cc[0] = c + delta
	else
		cc[0] = c
	end

	if (r + height[0]) >= hh[0]
		delta = hh[0] - (r + height[0])
		rr[0] = r + delta
	else
		rr[0] = r
	end

	if r < 0
		rr[0] = 0
	end

	if c < 0
		cc[0] = 0
	end

	Ncurses.mvderwin(subwin,rr[0],cc[0])
end

#################################################################################
# Initialize 																 	#
#################################################################################

Ncurses.initscr
Ncurses.noecho
Ncurses.curs_set(0)
Ncurses.cbreak
Ncurses.stdscr # initialize stdscr? Might be active by default
Ncurses.keypad(stdscr,true)
sd_y = []
sd_x = []
Ncurses.getmaxyx(stdscr,sd_y,sd_x)

# Welcome Streen
Ncurses.mvwaddstr(stdscr, sd_y[0] / 2, sd_x[0]  / 2, "Welcome to Move!")
Ncurses.mvwaddstr(stdscr, sd_y[0] / 2 + 1, sd_x[0] / 2, "rows = #{sd_y[0]}, rows = #{sd_x[0]}")
Ncurses.refresh
Ncurses.getch
Ncurses.clear
Ncurses.refresh

# Make Game Map
field = Ncurses.newwin(sd_y[0] * 2, sd_x[0] * 2, 0, 0)
viewp = Ncurses.subwin(field,sd_y[0], sd_x[0], 0, 0)

# Draw borders, terrain and player
draw_map(field)
f_x = []
f_y = []
Ncurses.getmaxyx(field,f_y,f_x)
startx = (f_x[0] / 4)
starty = (f_y[0] / 4)
p = Character.new(starty, startx)
Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
Ncurses.wrefresh(viewp)

#################################################################################
# Game Loop 																 	#
#################################################################################

while 1
=begin	
	# Resize window to the terminal screen
	new_y = []
	new_x = []
	Ncurses.getmaxyx(stdscr,new_y,new_x)

	if (new_y != parent_y || new_x != parent_x)
		Ncurses.wclear(viewp)

		sd_x[0] = new_x[0]
		sd_y[0] = new_y[0]

		######viewp.resize(new_y, new_x) # Resizes window to terminal screen
		borders(viewp) # Redraw new borders
		simple_generate(field) # Put snow back on map
		Ncurses.wrefresh(viewp)
		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
		Ncurses.wrefresh(field)
	end
=end
	#Ncurses.mvwaddstr(viewp,1,1,"Screen lines = #{sd_y[0]}, Screen cols = #{sd_x[0]}")
	#Ncurses.mvwaddstr(viewp,2,1,"Player lines = #{p.px}, Player cols = #{p.py}")
	input = Ncurses.getch
	case input
    when KEY_UP # move up
    	p.px -= 1 if p.px > 1
	    	Ncurses.mvwaddstr(field, p.px + 1, p.py, " ") # Looks like footprints
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_DOWN # move down
    	p.px += 1 if p.px < (f_y[0] - 2)
	    	Ncurses.mvwaddstr(field, p.px - 1, p.py, " ") # Looks like footprints
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_RIGHT # move right
    	p.py += 1 if p.py < (f_x[0] - 2)
	    	Ncurses.mvwaddstr(field, p.px, p.py - 1, " ") # Looks like footprints
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
	when KEY_LEFT # move left
    	p.py -= 1 if p.py > 1
	    	Ncurses.mvwaddstr(field, p.px, p.py + 1, " ") # Looks like footprints
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_F2 # Quit Game
    	break
    when KEY_F3 # Reset the Game
    	Ncurses.wclear(field)
    	draw_map(field)
    	p.px = 2
    	p.py = 2
    	Ncurses.mvwaddstr(field, 2, 2, "#{p.symb}")
    	Ncurses.wrefresh(viewp)
    else
    	Ncurses.flash
    	Ncurses.wrefresh(viewp)
    end
end

Ncurses.clear
Ncurses.mvwaddstr(stdscr, sd_y[0] / 2, sd_x[0] / 2, "Good Bye!")
Ncurses.wrefresh(stdscr)
Ncurses.getch
Ncurses.endwin