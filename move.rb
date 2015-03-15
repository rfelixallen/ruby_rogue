require 'curses'
include Curses

# TODO
# Center viewport on the character, and make the window bigger than the viewport.
#   Currently, the viewport moves.
#   Need to get the viewport to stay, and everyone else moves

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
	# Calculate player x,y as center
	# Set r,c to be the top left corner of the window
	# Set move(r,c)
	r = px - (max_lines / 2)	# get player x and subtract it from the half point
	c = py - (max_cols / 2)		# get player y and subtract it from the half point
	h = subwin.maxx				# get current subwindow max x
	w = subwin.maxy				# get current subwindow max y

	# if c is greater than max_cols
	if c + max_cols >= w
		delta = w - (c + max_cols)
		cc = c + delta
	else
		cc = c
	end
	if r + max_lines >= h
		delta = h - (r + max_lines)
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

max_lines = 40 # I set this because lines/cols were janky to work with.
max_cols = 40

init_screen
crmode # Tell curses to only accept 1 character input
noecho # Inputted characters wont show on the screen
curs_set(0)	# Gets rid of blinking cursor
start_color
init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 

# Initialize the main window
win = Window.new(max_lines * 2,max_cols * 2,0,0) # Make the window lines/cols the same for subwindow to make the border look nice
win.box("|", "-")
win.refresh
getch

# Begin player in the center of the world
start_x = win.maxx / 2
start_y = win.maxy / 2

# Initialize the sub window
viewp = win.subwin(max_lines,max_cols, 0, 0)
p = Character.new(start_x,start_y)
win.setpos(p.px, p.py)  # Add player as a test
win.addstr("#{p.symb}")
win.refresh

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
    	viewp.refresh
    when 's'
    	p.px += 1 if p.px < ((max_lines * 2) - 2)
		    win.setpos(p.px - 1, p.py)
	    	win.addstr("\"") # Looks like footprints
	    	win.setpos(p.px, p.py)
	    	win.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,win.maxx,win.maxy)
    	viewp.refresh
    when 'd'
    	p.py += 1 if p.py < ((max_cols * 2) - 2)
		    win.setpos(p.px, p.py - 1)
	    	win.addstr("\"") # Looks like footprints
	    	win.setpos(p.px, p.py)
	    	win.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,win.maxx,win.maxy)
		viewp.refresh
	when 'a'
    	p.py -= 1 if p.py > 1
		    win.setpos(p.px, p.py + 1)
	    	win.addstr("\"") # Looks like footprints
	    	win.setpos(p.px, p.py)
	    	win.addstr("#{p.symb}")
	    	center(viewp,p.px,p.py,win.maxx,win.maxy)
		viewp.refresh
    when 'q'
    	break
    else
    	flash
    	viewp.refresh
    end
end


#win.close # Quit the program