# TODO
# Add a perlin noise algorithim

require 'perlin_noise'
require 'curses'
include Curses
# This is to test adding Terrain to a map.

def simple_generate(viewp, max_lines, max_cols)
	# Fill in all spaces with random 1-3 tiles.
	i = 1
	j = 1
	while i < max_lines - 1
		# if i || j == 0 || max, skip
		n = rand(0..2)
		if j == max_cols - 1
			i += 1
			j = 1
		else
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
			j += 1
		end
	end
end

def building(viewp, max_lines, max_cols)
	i = 1
	viewp.setpos(max_lines / 2, max_cols / 2)
	viewp.addstr("|=======|")
	while i < 8
		viewp.setpos(((max_lines / 2) + i), max_cols / 2)
		viewp.addstr("|       |")
		i += 1
	end
	viewp.setpos(((max_lines / 2) + 8), max_cols / 2)
	viewp.addstr("|==b d==|")
	viewp.setpos(((max_lines / 2) + 4), max_cols / 2)
	viewp.addstr("|   H   |")
	viewp.refresh
end

def perlin_generate(viewp, max_lines, max_cols)

end

max_lines = 40 # I set this because lines/cols were janky to work with.
max_cols = 40
grid = [0,0]

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
 simple_generate(viewp, max_lines, max_cols)
# building(viewp, max_lines, max_cols)


getch