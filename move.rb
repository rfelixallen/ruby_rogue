require 'curses'
include Curses
init_screen
crmode # Tell curses to only accept 1 character input
noecho # Inputted characters wont show on the screen
curs_set(0)	# Gets rid of blinking cursor
start_color
init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 
player = '@'

# Initialize the main window
win = Window.new(20,20,0,0)
win.box("|", "-")
win.refresh
getch

# Initialize the sub window
viewp = win.subwin(20, 20, 0, 0)
viewp.refresh

while input = getch
    viewp.setpos(2, 3)  # Add player as a test
    viewp.addstr("#{player}")
    case input
    when 'q'
    	break
    else
    	flash
    	viewp.refresh
    end
end

getch
win.close # Quit the program