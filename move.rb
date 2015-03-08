require 'curses'
include Curses

p = '@'
px = 2
py = 2

init_screen
crmode # Tell curses to only accept 1 character input
noecho # Inputted characters wont show on the screen
curs_set(0)	# Gets rid of blinking cursor
start_color
init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 

# Initialize the main window
win = Window.new(20,20,0,0)
win.box("|", "-")
win.refresh
getch

# Initialize the sub window
viewp = win.subwin(20, 20, 0, 0)
viewp.setpos(px, py)  # Add player as a test
viewp.addstr("#{p}")
viewp.refresh

while input = getch
    case input
    when 'w'
    	px -= 1 if px > 1
	    	viewp.setpos(px + 1, py)
    		viewp.addstr(" ")
	    	viewp.setpos(px, py)
	    	viewp.addstr("#{p}")
    	viewp.refresh
    when 's'
    	px += 1 if px < 18
		    viewp.setpos(px - 1, py)
	    	viewp.addstr(" ")
	    	viewp.setpos(px, py)
	    	viewp.addstr("#{p}")
    	viewp.refresh
    when 'd'
    	py += 1 if py < 18
		    viewp.setpos(px, py - 1)
	    	viewp.addstr(" ")
			viewp.setpos(px, py)
			viewp.addstr("#{p}")
		viewp.refresh
	when 'a'
    	py -= 1 if py > 1
		    viewp.setpos(px, py + 1)
	    	viewp.addstr(" ")
			viewp.setpos(px, py)
			viewp.addstr("#{p}")
		viewp.refresh
    when 'q'
    	break
    when 'w'
    	flash
    else
    	viewp.refresh
    end
end


#win.close # Quit the program