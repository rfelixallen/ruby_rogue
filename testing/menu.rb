require 'ncurses'
include Ncurses

def drawmenu(item)
	c = 0
	mainmenu = "Main Menu"
	menu = ["Answer E-mail", "Off to the Web","Word Processing","Financial Management","Maintenance","Shutdown"]
	Ncurses.clear
	Ncurses.addstr(mainmenu)
	while c < 6
		if c == item
			Ncurses.attron(A_REVERSE)
			Ncurses.mvaddstr(3 + (c * 2), 20, menu[c])
			Ncurses.attroff(A_REVERSE)
		end
		c += 1
	end
	Ncurses.mvaddstr(17,25,"Use arrow keys to move, Enter to select:")
	Ncurses.refresh
end

menuitem = 0
Ncurses.initscr
drawmenu(menuitem)
Ncurses.keypad(stdscr,true)
Ncurses.noecho
key = 0
while key != 113
	drawmenu(menuitem)
	key = Ncurses.getch
	case key
	when KEY_DOWN
		menuitem += 1
		if (menuitem > 5) 
			menuitem = 0
			#break
		end
	when KEY_UP
		menuitem -= 1
		if (menuitem < 0) 
			menuitem = 5
			#break
		end
	else
		Ncurses.flash
	end
end