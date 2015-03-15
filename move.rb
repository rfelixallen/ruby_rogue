require 'curses'
include Curses

# TODO
# Center viewport on the character, and make the window bigger than the viewport.

def center(x,y)
end

max_lines = 40 # I set this because lines/cols were janky to work with.
max_cols = 40

p = '@'
px = 2
py = 2

monster = 'M'
mx = max_lines - 4
my = max_cols - 4
def monster_move
	viewp.setpos(px - mx, p)
end

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

# Initialize the sub window
viewp = win.subwin(max_lines,max_cols, 0, 0)
viewp.setpos(px, py)  # Add player as a test
viewp.addstr("#{p}")
viewp.setpos(mx, my) # Add monster
viewp.addstr("#{monster}")
viewp.refresh

# I could not keyboard input to work, use wasd instead
while input = getch
    case input
    when 'w'
    	px -= 1 if px > 1
	    	viewp.setpos(px + 1, py)
    		viewp.addstr("\"") # Looks like footprints
	    	viewp.setpos(px, py)
	    	viewp.addstr("#{p}")
    	viewp.refresh
    when 's'
    	px += 1 if px < ((max_lines * 2) - 2)
		    viewp.setpos(px - 1, py)
	    	viewp.addstr("\"") # Looks like footprints
	    	viewp.setpos(px, py)
	    	viewp.addstr("#{p}")
    	viewp.refresh
    when 'd'
    	py += 1 if py < ((max_cols * 2) - 2)
		    viewp.setpos(px, py - 1)
	    	viewp.addstr("\"") # Looks like footprints
			viewp.setpos(px, py)
			viewp.addstr("#{p}")
		viewp.refresh
	when 'a'
    	py -= 1 if py > 1
		    viewp.setpos(px, py + 1)
	    	viewp.addstr("\"") # Looks like footprints
			viewp.setpos(px, py)
			viewp.addstr("#{p}")
		viewp.refresh
    when 'q'
    	break
    else
    	flash
    	viewp.refresh
    end
end


#win.close # Quit the program