require 'curses'
include Curses

# This is to test adding Terrain to a map.

max_lines = 40 # I set this because lines/cols were janky to work with.
max_cols = 40

init_screen
crmode # Tell curses to only accept 1 character input
noecho # Inputted characters wont show on the screen
curs_set(0)	# Gets rid of blinking cursor
start_color
init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 

# Initialize the main window
win = Window.new(max_lines,max_cols,0,0)
win.box("|", "-")
win.refresh
getch

# Initialize the sub window
viewp = win.subwin(max_lines,max_cols, 0, 0)
viewp.refresh
getch

# Generate terrain
max_lines.times do |i|
	i.times do |j|
		# if i || j == 0 || max, skip
		x = j / max_cols
		y = i / max_lines

		n = rand(0..2)

		if n == 0
			viewp.setpos(i,j)
			viewp.addstr(" ")
			viewp.refresh
		elsif n == 1
			viewp.setpos(i,j)
			viewp.addstr("#")
			viewp.refresh
		else
			viewp.setpos(i,j)
			viewp.addstr("~")
			viewp.refresh
		end
	end
end

getch