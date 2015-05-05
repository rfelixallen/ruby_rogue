require 'ncurses'
include Ncurses

def drawmenu(item)
	c = 0
	mainmenu = "Main Menu"
	menu = ["Answer E-mail", "Off to the Web","Word Processing","Financial Management","Maintenance","Shutdown"]
	NCurses.clear
	NCurses.addstr(mainmenu)
	while c < 6
		if c == item
			NCurses.attron(A_REVERSE)
			NCurses.mvaddstr(3 + (c * 2), 20, menu[c])
			NCurses.attroff(A_REVERSE)
		end
		c += 1
	end
	Ncurses.mvaddstr(17,25,"Use arrow keys to movel Enter to select:")
	Ncurses.refresh
end

menuitem = 0
initscr
drawmenu(menuitem)
Ncurses.keypad(stdscr,true)
Ncurses.noecho
key = 0
while key != '\n'
	key = Ncurses.getch
	case key
	when KEY_DOWN
		menuitem++
		if (menuitem > 5) menuitem = 0
			break
		end
	when KEY_UP
		menuitem--
		if (menuitem < 0) menuitem = 5
			break
		end
	else
		break
	end
end