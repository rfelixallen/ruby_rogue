require 'perlin_noise'
require 'ncurses'
include Ncurses

##################################################################################
# TODO																			 #
#   *Add Perlin Noise
#  	*Add Enemy code																 #
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
	# Maybe this should be a class?
end

def target_position(window, lin, col)
	target = Ncurses.mvwinch(window, lin, col)
	if target == '~' #or target == ' '
		return true
	else
		return false
	end
end

def move_character(window,p)
	if target_position(window, p.px - 1, p.py) == true
		Ncurses.mvwaddstr(window, p.px + 1, p.py, " ") # for moving north
    	Ncurses.mvwaddstr(window, p.px, p.py, "#{p.symb}")
    else
    	Ncurses.flash
    end
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

def fade(t)
	return t * t * t * (t * (t * 6 - 15) + 10)
end

def lerp(t,a,b)
	return a + t * (b - a)
end

def grad(hash,x,y,z)
	h = hash & 15
	u = h < 8 ? x : y
	v = h < 4 ? y : h == 12 || h == 14 ? x : z
	return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v)
end

def noise(x,y,z)
	p = [151,160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,102,143,54, 65,25,63,161,1,216,80,73,209,76,132,187,208, 89,18,169,200,196,135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180]

	# Find the unit cube that contains the point
	X = x.floor & 255
	Y = y.floor & 255
	Z = z.floor & 255

	# Find the relative x, y, z of point in cube
	x -= x.floor
	y -= y.floor
	z -= z.floor

	# Compute fade curves for x, y, z
	u = x.fade
	v = y.fade
	w = z.fade

	# Hash coordinates of the 8 cube corners
	A = p[X] + Y
	AA = p[A] + Z
	AB = p[A + 1] + Z
	B = p[X + 1] + Y
	BA = p[B] + Z
	BB = p[B + 1] + Z

	res = lerp(w, lerp(v, lerp(u, grad(p[AA], x, y, z), grad(p[BA], x-1, y, z)), lerp(u, grad(p[AB], x, y-1, z), grad(p[BB], x-1, y-1, z))),	lerp(v, lerp(u, grad(p[AA+1], x, y, z-1), grad(p[BA+1], x-1, y, z-1)), lerp(u, grad(p[AB+1], x, y-1, z-1),	grad(p[BB+1], x-1, y-1, z-1))))
	return (res + 1.0)/2.0
end

def generate_perlin(window)
	# Use Perlin Noise algorithim to draw terrain
	borders(window)
	
	pn = Perlin::Noise.new 2

	i = 1
	w_y = []
	w_x = []
	Ncurses.getmaxyx(window,w_y,w_x)
	while i < w_x[0] - 1
		j = 1
		while j < w_y[0] - 1
			x = j / w_y[0]
			y = i / w_x[0]
			n = pn.noise(10 * x, 10 * y, 0.8)
			case 
			when n < 0.35
				Ncurses.mvwaddstr(window, i, j, "#")
			when n >= 0.35 && n < 0.6
				Ncurses.mvwaddstr(window, i, j, "*")
			when n >= 0.6 && n < 0.8
				Ncurses.mvwaddstr(window, i, j, "^")
			else
				Ncurses.mvwaddstr(window, i, j, "~")
			end
		j += 1
		end
		i += 1
	end
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

def message(window,message)
	Ncurses.wclear(window)
	borders(window)
	Ncurses.mvwaddstr(window, 1, 2, "#{message}")
	Ncurses.wrefresh(window)
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
console = Ncurses.newwin(3, 25, 25, 0) # Must not exceed size of terminal

# Draw borders, terrain and player
#draw_map(field) # Draws a plain map with one terrain type.
walkable = ["32","126",32,126," ","~"] #walkable.include?('~')
#generate_random(field) # Draws a map with x random characters, randomly chosen for each pixel.
generate_perlin(field)
#building(field,10,10)
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

borders(console)
Ncurses.mvwaddstr(console, 1, 2, "Hello!")
Ncurses.wrefresh(console)
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
    	#p.px -= 1 if p.px > 1 && walkable.include?(Ncurses.mvwinch(field,p.px - 1, p.py)) 
    	step = Ncurses.mvwinch(field,p.px - 1, p.py)
    	message(console,step)
    	p.px -= 1 if p.px > 1 && (step == 32 or step == 126)
			if (step == 32 or step == 126)
				Ncurses.mvwaddstr(field, p.px + 1, p.py, " ") # for moving north
    		end
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
			#move_character(field,p)
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_DOWN # move down
    	step = Ncurses.mvwinch(field,p.px + 1, p.py)
    	message(console,step)
    	p.px += 1 if p.px < (f_y[0] - 2) && (step == 32 or step == 126)
			if (step == 32 or step == 126)
				Ncurses.mvwaddstr(field, p.px - 1, p.py, " ") # for moving north
    		end
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_RIGHT # move right
    	step = Ncurses.mvwinch(field,p.px, p.py + 1)
    	message(console,step)
    	p.py += 1 if p.py < (f_x[0] - 2) && (step == 32 or step == 126)
			if (step == 32 or step == 126)
				Ncurses.mvwaddstr(field, p.px, p.py - 1, " ") # for moving north
    		end
    		Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
	when KEY_LEFT # move left
		step = Ncurses.mvwinch(field,p.px, p.py - 1)
    	message(console,step)
    	p.py -= 1 if p.py > 1 && (step == 32 or step == 126)
			if (step == 32 or step == 126)
				Ncurses.mvwaddstr(field, p.px, p.py + 1, " ") # for moving north
    		end
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