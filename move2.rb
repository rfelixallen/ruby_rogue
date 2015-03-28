require 'curses'
include Curses

class Character
	attr_accessor :px, :py, :symb
	def initialize(px, py)
		@symb = '@'
		@px = px 
		@py = py
	end
end

def mvwprintw(window, x, y, symb)
	window.setpos(x,y)
	window.addch("#{symb}")
end

def borders(field)
	field.clear
	i = 0
	while i <= (lines - 1) do
		mvwprintw(field, i, 0, "|")
		mvwprintw(field, i, cols - 1, "|")
		i += 1
	end

	j = 0
	while j <= (cols - 1) do
		mvwprintw(field, 0, j, "+")
		mvwprintw(field, lines - 1, j, "+")
		j += 1
	end
	
	field.setpos(1,1)
	field.addstr("Field") 
	field.refresh
end

def simple_generate(window)
	i = 1
	max_x = window.maxx
	max_y = window.maxy
	while i < max_y
		j = 1
		while j < max_x
			mvwprintw(window, i, j, "~")
			window.refresh
			j += 1
		end
		i += 1
	end
end

init_screen
noecho
curs_set(0)
stdscr # initialize stdscr? Might be active by default

# Welcome Streen
setpos(lines / 2, cols  / 2)
addstr("Welcome to Move!")
setpos((lines / 2) + 1, cols  / 2)
addstr("x = #{stdscr.maxx}, y = #{stdscr.maxy}")
refresh
getch

parent_x = stdscr.maxx # Gets x of terminal screen
parent_y = stdscr.maxy # Gets y of terminal screen
field = stdscr.subwin(parent_y, parent_x, 0, 0)
game_map = field.subwin(parent_y, parent_x, 0, 0)


borders(field)
simple_generate(game_map)
field.setpos(lines / 2, cols  / 2)
field.addstr("x = #{parent_x}, y = #{parent_y}")
field.setpos((lines / 2) + 1, cols  / 2)
field.addstr("map x = #{game_map.maxx}, map y = #{game_map.maxy}")

p = Character.new(3, 3)
mvwprintw(game_map, p.px, p.py, "#{p.symb}")
game_map.refresh

while 1
	# Resize window to the terminal screen
	new_y = stdscr.maxy
	new_x = stdscr.maxx

	if (new_y != parent_y || new_x != parent_x)
		field.clear

		parent_x = new_x
		parent_y = new_y

		field.resize(new_y, new_x)
		borders(field)
		field.setpos(lines / 2, cols  / 2)
		field.addstr("x = #{parent_x}, y = #{parent_y}")
		field.setpos((lines / 2) + 1, cols  / 2)
		field.addstr("map x = #{game_map.maxx}, map y = #{game_map.maxy}")
		field.refresh
		mvwprintw(game_map, p.px, p.py, "#{p.symb}")
		game_map.refresh
	end
	field.refresh

	input = getch
	case input
    when 'w' # move up
    	p.px -= 1 if p.px > 1
	    	mvwprintw(game_map, p.px + 1, p.py, "\"") # Looks like footprints
    		mvwprintw(game_map, p.px, p.py, "#{p.symb}")
	    	#center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
    	#viewp.refresh
    	game_map.refresh
    when 's' # move down
    	p.px += 1 if p.px < (game_map.maxy - 1)
	    	mvwprintw(game_map, p.px - 1, p.py, "\"") # Looks like footprints
    		mvwprintw(game_map, p.px, p.py, "#{p.symb}")
	    	#center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
    	#viewp.refresh
    	game_map.refresh
    when 'd' # move right
    	p.py += 1 if p.py < (game_map.maxx - 1)
	    	mvwprintw(game_map, p.px, p.py - 1, "\"") # Looks like footprints
    		mvwprintw(game_map, p.px, p.py, "#{p.symb}")
	    	#center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
		#viewp.refresh
    	game_map.refresh
	when 'a' # move left
    	p.py -= 1 if p.py > 1
	    	mvwprintw(game_map, p.px, p.py + 1, "\"") # Looks like footprints
    		mvwprintw(game_map, p.px, p.py, "#{p.symb}")
	    	#center(viewp,p.px,p.py,game_map.maxx,game_map.maxy)
		#viewp.refresh
    	game_map.refresh
    when 'q'
    	break
    else
    	flash
    	game_map.refresh
    end
end

field.clear
field.setpos(lines / 2, cols  / 2)
field.addstr("Good Bye!")
field.refresh
field.close # free up memory
refresh
getch