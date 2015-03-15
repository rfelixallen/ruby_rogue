require 'curses'
include Curses

# TODO
# Center viewport on the character, and make the window bigger than the viewport.

class Character
	attr_accessor :px, :py, :symb
	def initialize(px, py)
		@symb = '@'
		@px = px 
		@py = py
	end
	def bio
		puts "Player has $#{money} and #{items}.\n"
	end
end

def center(x,y)

end

max_lines = 40 # I set this because lines/cols were janky to work with.
max_cols = 40
=begin
p = '@'
px = 2
py = 2

monster = 'M'
mx = max_lines - 4
my = max_cols - 4
def monster_move
	viewp.setpos(px - mx, p)
end
=end
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
p = Character.new(2,2)
viewp.setpos(p.px, p.py)  # Add player as a test
viewp.addstr("#{p.symb}")
# viewp.setpos(mx, my) # Add monster
# viewp.addstr("#{monster}")
viewp.refresh

# I could not keyboard input to work, use wasd instead
while input = getch
    # viewp.center(p)
    case input
    when 'w'
    	p.px -= 1 if p.px > 1
	    	viewp.setpos(p.px + 1, p.py)
    		viewp.addstr("\"") # Looks like footprints
	    	viewp.setpos(p.px, p.py)
	    	viewp.addstr("#{p.symb}")
    	viewp.refresh
    when 's'
    	p.px += 1 if p.px < ((max_lines * 2) - 2)
		    viewp.setpos(p.px - 1, p.py)
	    	viewp.addstr("\"") # Looks like footprints
	    	viewp.setpos(p.px, p.py)
	    	viewp.addstr("#{p.symb}")
    	viewp.refresh
    when 'd'
    	p.py += 1 if p.py < ((max_cols * 2) - 2)
		    viewp.setpos(p.px, p.py - 1)
	    	viewp.addstr("\"") # Looks like footprints
	    	viewp.setpos(p.px, p.py)
	    	viewp.addstr("#{p.symb}")
		viewp.refresh
	when 'a'
    	p.py -= 1 if p.py > 1
		    viewp.setpos(p.px, p.py + 1)
	    	viewp.addstr("\"") # Looks like footprints
	    	viewp.setpos(p.px, p.py)
	    	viewp.addstr("#{p.symb}")
		viewp.refresh
    when 'q'
    	break
    else
    	flash
    	viewp.refresh
    end
end


#win.close # Quit the program