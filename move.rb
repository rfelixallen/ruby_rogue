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

def simple_generate(window)
	# Fill in all spaces with random 1-3 tiles.
	x = window.maxx
	y = window.maxy
	i = 1
	j = 1
	while j < y - 1
		while i < x - 1
			window.setpos(j,i)
			window.addstr("~")
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

# Activate Colors
start_color
init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 

# Initialize the Game Map
win = Window.new(80,80,0,0) # Make the window lines/cols the same for subwindow to make the border look nice
simple_generate(win)
win.refresh
getch

parent_x = stdscr.maxx
parent_y = stdscr.maxy

# Begin player in the center of the world
start_x = win.maxx / 2
start_y = win.maxy / 2

# Initialize the viewport, a subwindow of Standard Screen
viewp = stdscr.subwin(parent_x, parent_y, 0, 0)
p = Character.new(start_x,start_y)
win.setpos(p.px, p.py)  # Add player as a test
win.addstr("#{p.symb}")
center(viewp,p.px,p.py,win.maxx,win.maxy)
win.refresh
viewp.refresh



# I could not keyboard input to work, use wasd instead
while input = getch
    case input
    when 'w'
    	p.px -= 1 if p.px > 1
	    	win.setpos(p.px + 1, p.py)
    		win.addstr("\"") # Looks like footprints
	    	win.setpos(p.px, p.py)
	    	win.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,win.maxx,win.maxy)
    	#viewp.refresh
    	win.refresh
    when 's'
    	p.px += 1 if p.px < ((max_lines * 2) - 2)
		    win.setpos(p.px - 1, p.py)
	    	win.addstr("\"") # Looks like footprints
	    	win.setpos(p.px, p.py)
	    	win.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,win.maxx,win.maxy)
    	#viewp.refresh
    	win.refresh
    when 'd'
    	p.py += 1 if p.py < ((max_cols * 2) - 2)
		    win.setpos(p.px, p.py - 1)
	    	win.addstr("\"") # Looks like footprints
	    	win.setpos(p.px, p.py)
	    	win.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,win.maxx,win.maxy)
		#viewp.refresh
    	win.refresh
	when 'a'
    	p.py -= 1 if p.py > 1
		    win.setpos(p.px, p.py + 1)
	    	win.addstr("\"") # Looks like footprints
	    	win.setpos(p.px, p.py)
	    	win.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,win.maxx,win.maxy)
		#viewp.refresh
    	win.refresh
    when 'q'
    	break
    else
    	flash
    	viewp.refresh
    end
end


#win.close # Quit the program