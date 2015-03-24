require 'curses'
include Curses
################################################################################
# TODO
# Center viewport on the character, and make the window bigger than the viewport.
#   Viewport is locked in place, and not following player.
#  Problem somewhere with stdscr, window, subwindow
#  Should be able to resize window to terminal with stdscr
################################################################################
# Class & Methods
################################################################################
class Character
	attr_accessor :px, :py, :symb
	def initialize(px, py)
		@symb = '@'
		@px = px 
		@py = py
	end
end

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

# Fill in all spaces with a single character.
def simple_generate(window)
	x = window.maxx
	y = window.maxy
	i = 1
	j = 1
	while j < y - 1
		while i < x - 1
			mvwprintw(window, j, i, "~")
			window.refresh
			i += 1
			if i >= x - 1
				j += 1
				i = 1
			end
			if j >= y -1
				break
			end
		end
	end
end

# Move cursor to position in a window and add a character
def mvwprintw(window, y, x, symb)
	window.setpos(y,x)
	window.addch("#{symb}")
end

# Update Screen borders
def borders(subwindow)
	subwindow.clear
	i = 0
	while i <= (lines - 1) do
		mvwprintw(subwindow, i, 0, "|")
		mvwprintw(subwindow, i, cols - 1, "|")
		i += 1
	end

	j = 0
	while j <= (cols - 1) do
		mvwprintw(subwindow, 0, j, "+")
		mvwprintw(subwindow, lines - 1, j, "+")
		j += 1
	end
	subwindow.refresh
end
################################################################################
# Global Variables
################################################################################
max_lines = 40 # I set this because lines/cols were janky to work with.
max_cols = 40

# Set up screens
init_screen # Begin Curses
crmode # Tell curses to only accept 1 character input
noecho # Inputted characters wont show on the screen
curs_set(0)	# Gets rid of blinking cursor

stdscr # Initialize default Standard Screen
# Set variables equal to current terminal screen size
parent_x = stdscr.maxx
parent_y = stdscr.maxy

# Activate Colors
start_color
init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 

# Initialize the Game Map
game_map = Window.new(parent_x, parent_y,0,0)

# Set player starting position
start_x = game_map.maxx / 2
start_y = game_map.maxy / 2

# Initialize the viewport, a subwindow of Standard Screen
viewp = game_map.subwin(parent_x, parent_y, 0, 0)
borders(viewp)
getch

simple_generate(game_map)
game_map.refresh
getch

p = Character.new(start_x,start_y)
game_map.setpos(p.px, p.py)  # Add player as a test
game_map.addstr("#{p.symb}")
center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
game_map.refresh
viewp.refresh



# I could not keyboard input to work, use wasd instead
while input = getch
    case input
    when 'w'
    	p.px -= 1 if p.px > 1
	    	game_map.setpos(p.px + 1, p.py)
    		game_map.addstr("\"") # Looks like footprints
	    	game_map.setpos(p.px, p.py)
	    	game_map.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
    	#viewp.refresh
    	game_map.refresh
    when 's'
    	p.px += 1 if p.px < ((max_lines * 2) - 2)
		    game_map.setpos(p.px - 1, p.py)
	    	game_map.addstr("\"") # Looks like footprints
	    	game_map.setpos(p.px, p.py)
	    	game_map.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
    	#viewp.refresh
    	game_map.refresh
    when 'd'
    	p.py += 1 if p.py < ((max_cols * 2) - 2)
		    game_map.setpos(p.px, p.py - 1)
	    	game_map.addstr("\"") # Looks like footprints
	    	game_map.setpos(p.px, p.py)
	    	game_map.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
		#viewp.refresh
    	game_map.refresh
	when 'a'
    	p.py -= 1 if p.py > 1
		    game_map.setpos(p.px, p.py + 1)
	    	game_map.addstr("\"") # Looks like footprints
	    	game_map.setpos(p.px, p.py)
	    	game_map.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
		#viewp.refresh
    	game_map.refresh
    when 'q'
    	break
    else
    	flash
    	viewp.refresh
    end
end


#game_map.close # Quit the program