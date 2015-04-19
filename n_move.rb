require 'ncurses'
include Ncurses

##################################################################################
# TODO																			 #							 #
#  	*Add Enemy																	 #
#	*Add impassible terrain										                 #
# 	*Add z-levels																 #
#   *Add color																	 #
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

class Monster
	attr_accessor :mx, :my, :symb
	def initialize(mx, my)
		@symb = 'M'
		@mx = mx 
		@my = my
	end
end
=begin
def add_player(window, orow, ocol, nrow, ncol, symb)
	if ((row_0 >= 0 && row_0 < height) && (col_0 >= 0 && col_0 < width))
		mvwaddstr(window, orow, ocol, ' ')
		mvwaddstr(window, nrow, ncol, symb)
end

def move_monster(window, orow, ocol, nrow, ncol, symb)
	
	if ((row_0 >= 0 && row_0 < height) && (col_0 >= 0 && col_0 < width))
		mvwaddstr(window, orow, ocol, ' ')
		mvwaddstr(window, nrow, ncol, symb)
	end
end
=end
def terrain_tiles
	# Pairs terrain name with icon
end

def borders(window)
		# Draws borders and fills all game map tiles with snow.
	i = 1
	w_y = []
	w_x = []
	Ncurses.getmaxyx(window,w_y,w_x)
	# Draw Borders
	# Draw side borders
	while i <= (w_y[0] - 1) do
		Ncurses.mvwaddstr(window, i, 0, "|")
		Ncurses.mvwaddstr(window, i, w_x[0] - 1, "|")
		i += 1
	end
	# Draw Top/bottom borders
	j = 0
	while j <= (w_x[0] - 1) do
		Ncurses.mvwaddstr(window, 0, j, "+")
		Ncurses.mvwaddstr(window, w_y[0] - 1, j, "+")
		j += 1
	end
end

def building(window, lines, cols)
	i = 1
	Ncurses.mvwaddstr(window, lines, cols, "|=======|")
	while i < 8
		Ncurses.mvwaddstr(window, lines + i, cols, "|       |")
		i += 1
	end
	Ncurses.mvwaddstr(window, lines + 4, cols, "|   H   |")
	Ncurses.mvwaddstr(window, lines + 8, cols, "|==b d==|")
end

def draw_map(window)
	borders(window)

	# Draw Terrain
	# Draw snow on every tile
	i = 1
	w_y = []
	w_x = []
	Ncurses.getmaxyx(window,w_y,w_x)
	while i < w_x[0] - 1
		j = 1
		while j < w_y[0] - 1
			Ncurses.mvwaddstr(window, i, j, "~")
			j += 1
		end
		i += 1
	end
end

def generate_random(window)
	borders(window)
	# Draws random characters to each tile
	i = 1
	w_y = []
	w_x = []
	Ncurses.getmaxyx(window,w_y,w_x)
	while i < w_x[0] - 1
		j = 1
		while j < w_y[0] - 1
			dice = rand(4)
			case dice 
			when 0
				Ncurses.mvwaddstr(window, i, j, "#")
			when 1
				Ncurses.mvwaddstr(window, i, j, "*")
			when 2
				Ncurses.mvwaddstr(window, i, j, "^")
			else
				Ncurses.mvwaddstr(window, i, j, "~")
			end
		j += 1
		end
		i += 1
	end
end

def generate_perlin(window)
	# Use Perlin Noise algorithim to draw terrain
end

def center(subwin,parent,p_rows,p_cols)
	rr = [] 	# Frame y Positions
	cc = [] 	# Frame x Positions
	Ncurses.getbegyx(subwin, rr, cc)

	hh = []		# Parent Window Height
	ww = []		# Parent Window Width
	Ncurses.getmaxyx(parent, hh, ww)

	height = [] # Frame Window Height
	width = []  # Frame Window Width
	Ncurses.getmaxyx(subwin, width, height)

	r = p_rows - (height[0] / 2)
	c = p_cols - (width[0] / 2)	

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
#field = Ncurses.newwin(sd_y[0] * 2, sd_x[0] * 2, 0, 0)
#viewp = Ncurses.derwin(field,sd_y[0], sd_x[0], 0, 0)
field = Ncurses.newwin(100, 100, 0, 0)
viewp = Ncurses.derwin(field,25, 25, 0, 0) # Must not exceed size of terminal

# Draw borders, terrain and player
#draw_map(field) # Draws a plain map with one terrain type.

generate_random(field) # Draws a map with x random characters, randomly chosen for each pixel.
building(field,10,10)
f_x = []
f_y = []
Ncurses.getmaxyx(field,f_y,f_x)
startx = (f_x[0] / 4)
starty = (f_y[0] / 4)
p = Character.new(starty, startx)
monster_exist = true
Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
if monster_exist == true
	m = Monster.new(f_y[0] - 10, f_x[0] - 10)
	Ncurses.mvwaddstr(field,m.mx,m.my,"#{m.symb}")
end
center(viewp,field,p.px,p.py)
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
	#Ncurses.mvwaddstr(viewp,1,1,"Screen lines = #{sd_y[0]}, Screen cols = #{sd_x[0]}") # FOR TESTING
	#Ncurses.mvwaddstr(viewp,2,1,"Player lines = #{p.px}, Player cols = #{p.py}") 		# FOR TESTING
	input = Ncurses.getch
	case input
    when KEY_UP # move up
    	p.px -= 1 if p.px > 1
	    	Ncurses.mvwaddstr(field, p.px + 1, p.py, " ")
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_DOWN # move down
    	p.px += 1 if p.px < (f_y[0] - 2)
	    	Ncurses.mvwaddstr(field, p.px - 1, p.py, " ")
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_RIGHT # move right
    	p.py += 1 if p.py < (f_x[0] - 2)
	    	Ncurses.mvwaddstr(field, p.px, p.py - 1, " ")
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
	when KEY_LEFT # move left
    	p.py -= 1 if p.py > 1
	    	Ncurses.mvwaddstr(field, p.px, p.py + 1, " ")
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

    # Monster Moves
    if monster_exist == true
    	# Check to move left
    	
    end


end

Ncurses.clear
Ncurses.mvwaddstr(stdscr, sd_y[0] / 2, sd_x[0] / 2, "Good Bye!")
Ncurses.wrefresh(stdscr)
Ncurses.getch
Ncurses.endwin