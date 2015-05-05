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
	attr_accessor :symb, :px, :py, :hp
	def initialize(px, py)
		@symb = '@'
		@px = px  # Player X location
		@py = py # Player Y location
		@hp = 10 # Hit Points
	end
end

class Monster
	attr_accessor :symb, :mx, :my, :hp
	def initialize(mx, my)
		@symb = 'M'
		@mx = mx 
		@my = my
		@hp = 3
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

def generate_perlin(window)
	# Use Perlin Noise algorithim to draw terrain
	borders(window)
	
	pn = Perlin::Noise.new 2
	contrast = Perlin::Curve.contrast(Perlin::Curve::CUBIC, 2)

	i = 1
	w_y = []
	w_x = []
	Ncurses.getmaxyx(window,w_y,w_x)
	while i < w_x[0] - 1
		j = 1
		while j < w_y[0] - 1
			x = j / w_y[0]
			y = i / w_x[0]
			n = pn[x * 10, y * 10]
			#n = contrast.call n
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
view_lines = 25
view_cols = 25
field = Ncurses.newwin(100, 100, 0, 0)
viewp = Ncurses.derwin(field,view_lines, view_cols, 0, 0) # Must not exceed size of terminal
console = Ncurses.newwin(3, view_cols, view_lines, 0) 
hud = Ncurses.newwin(view_lines + 3, 15, 0, view_lines) 

# Draw borders, terrain and player
draw_map(field) # Draws a plain map with one terrain type.
walkable = ["32","126",32,126," ","~"] #walkable.include?('~')
#generate_random(field) # Draws a map with x random characters, randomly chosen for each pixel.
#generate_perlin(field)
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
	m = Monster.new(starty + 10, startx + 10)
	Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
end
center(viewp,field,p.px,p.py)
Ncurses.wrefresh(viewp)

# Set up Console
borders(console)
Ncurses.mvwaddstr(console, 1, 2, "Hello!")
Ncurses.wrefresh(console)

# Set up HUD
borders(hud)
Ncurses.mvwaddstr(hud, 1, 1, "The Game")
Ncurses.mvwaddstr(hud, 2, 1, "Time: 16:04")
Ncurses.mvwaddstr(hud, 3, 1, "Temp: 16 F")
Ncurses.mvwaddstr(hud, 4, 1, "HP: #{p.hp}")
Ncurses.mvwaddstr(hud, 5, 1, "Inventory:")
Ncurses.mvwaddstr(hud, 6, 1, "  -Club")
Ncurses.mvwaddstr(hud, 7, 1, "  -Flashlight")
Ncurses.mvwaddstr(hud, 8, 1, "P: #{p.px},#{p.py}")
Ncurses.mvwaddstr(hud, 9, 1, "M: #{m.mx},#{m.my}")
Ncurses.wrefresh(hud)
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
	Ncurses.mvwaddstr(hud, 8, 1, "P: #{p.px},#{p.py}")
	Ncurses.mvwaddstr(hud, 9, 1, "M: #{m.mx},#{m.my}")
	Ncurses.wrefresh(hud)
	case input
    when KEY_UP, 119 # move up
    	#p.px -= 1 if p.px > 1 && walkable.include?(Ncurses.mvwinch(field,p.px - 1, p.py)) 
    	step = Ncurses.mvwinch(field,p.px - 1, p.py)
    	message(console,step)
    	p.px -= 1 if p.px > 1 && (step == 32 or step == 126 or step == 77)
			if (step == 32 or step == 126)
				Ncurses.mvwaddstr(field, p.px + 1, p.py, " ")
				Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
			else step == 77
				p.px += 1
				m.hp -= 1
    		end
    		
			#move_character(field,p)
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_DOWN, 115 # move down
    	step = Ncurses.mvwinch(field,p.px + 1, p.py)
    	message(console,step)
    	p.px += 1 if p.px < (f_y[0] - 2) && (step == 32 or step == 126 or step == 77)
			if (step == 32 or step == 126)
				Ncurses.mvwaddstr(field, p.px - 1, p.py, " ")
				Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
			else step == 77
				p.px -= 1
				m.hp -= 1
    		end
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when KEY_RIGHT, 100 # move right
    	step = Ncurses.mvwinch(field,p.px, p.py + 1)
    	message(console,step)
    	p.py += 1 if p.py < (f_x[0] - 2) && (step == 32 or step == 126 or step == 77)
			if (step == 32 or step == 126)
				Ncurses.mvwaddstr(field, p.px, p.py - 1, " ")
				Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
			else step == 77
				p.py -= 1
				m.hp -= 1    		
    		end
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
	when KEY_LEFT, 97 # move left
		step = Ncurses.mvwinch(field,p.px, p.py - 1)
    	message(console,step)
    	p.py -= 1 if p.py > 1 && (step == 32 or step == 126 or step == 77)
			if (step == 32 or step == 126)
				Ncurses.mvwaddstr(field, p.px, p.py + 1, " ")
				Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
			else step == 77
				p.py += 1
				m.hp -= 1
    		end
	    center(viewp,field,p.px,p.py)
    	Ncurses.wrefresh(viewp)
    when 114, 82 # r or R
    	message(console,"6..4..zzZzZ..7..Zz")
    when KEY_F2, 113, 81 # Quit Game with F2, q or Q
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
    	message(console,input)
    	Ncurses.wrefresh(viewp)
    end

    # Monster Move (Chasing Mode)
    if monster_exist == true
    	flip1 = rand(2)
    	if flip1 == 0
	    	# Move Left
	    	step1 = Ncurses.mvwinch(field,m.mx, m.my - 1)
	    	step2 = Ncurses.mvwinch(field,m.mx, m.my + 1)
	    	if m.my > p.py && (step1 == 32 or step1 == 126 or step1 == 64)
		    	m.my -= 1
		    	if (step1 == 32 or step1 == 126)
					Ncurses.mvwaddstr(field, m.mx, m.my + 1, " ") # for moving north				
		    	else step1 == 64
					m.my += 1
					p.hp -= 1
				end
				Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
				Ncurses.wrefresh(viewp)
			# Move Right	    	
			elsif m.my < p.py && (step2 == 32 or step2 == 126 or step2 == 64)
	    		m.my += 1
	    		if (step2 == 32 or step2 == 126)
	    			Ncurses.mvwaddstr(field, m.mx, m.my - 1, " ") # for moving north	
				else step1 == 64
					m.my -= 1
					p.hp -= 1
				end
				Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
				Ncurses.wrefresh(viewp)
			 # Stay Put
	    	else m.my == p.py
		    	# Move Up
		    	step3 = Ncurses.mvwinch(field,m.mx - 1, m.my)
		    	step4 = Ncurses.mvwinch(field,m.mx + 1, m.my)
		    	if m.mx > p.px && (step3 == 32 or step3 == 126 or step3 == 64)
					m.mx -= 1
					if (step3 == 32 or step3 == 126)
						Ncurses.mvwaddstr(field, m.mx + 1, m.my, " ") # for moving north
					else step3 == 64
						m.mx += 1
						p.hp -= 1
					end
					Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
					Ncurses.wrefresh(viewp)
		    	# Move Down
		    	else m.mx < p.px && (step4 == 32 or step4 == 126 or step4 == 64)
					m.mx += 1
					if (step4 == 32 or step4 == 126)
						Ncurses.mvwaddstr(field, m.mx - 1, m.my, " ") # for moving north
					else step4 == 64
						m.mx -= 1
						p.hp -= 1
					end
					Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
					Ncurses.wrefresh(viewp)
				end
	    	end
		else	
	    	# Move Up
	    	step1 = Ncurses.mvwinch(field,m.mx - 1, m.my)
	    	step2 = Ncurses.mvwinch(field,m.mx + 1, m.my)
	    	if m.mx > p.px && (step1 == 32 or step1 == 126 or step1 == 64)
				m.mx -= 1
				Ncurses.mvwaddstr(field, m.mx + 1, m.my, " ") # for moving north
				Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
				Ncurses.wrefresh(viewp)
	    	# Move Down
	    	elsif m.mx < p.px && (step2 == 32 or step2 == 126 or step2 == 64)
				m.mx += 1
				Ncurses.mvwaddstr(field, m.mx - 1, m.my, " ") # for moving north
				Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
				Ncurses.wrefresh(viewp)
	    	else m.mx == p.px 
		    	# Move Left
		    	step3 = Ncurses.mvwinch(field,m.mx, m.my - 1)
		    	step4 = Ncurses.mvwinch(field,m.mx, m.my + 1)
		    	if m.my > p.py && (step3 == 32 or step3 == 126 or step3 == 64)
					m.my -= 1
					Ncurses.mvwaddstr(field, m.mx, m.my + 1, " ") # for moving north
					Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
					Ncurses.wrefresh(viewp)
				# Move Right
		    	else m.my < p.py && (step4 == 32 or step4 == 126 or step4 == 64)
					m.my += 1
					Ncurses.mvwaddstr(field, m.mx, m.my - 1, " ") # for moving north
					Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
					Ncurses.wrefresh(viewp)
				end
			end		
	    end
	end
end
Ncurses.clear
Ncurses.mvwaddstr(stdscr, sd_y[0] / 2, sd_x[0] / 2, "Good Bye!")
Ncurses.wrefresh(stdscr)
Ncurses.getch
Ncurses.endwin