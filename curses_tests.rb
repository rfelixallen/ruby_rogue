require 'curses'
include Curses

init_screen

l = lines.to_i
c = cols.to_i

setpos(0,0)
addch('1')
refresh
timeout=(500)

setpos(0,(c - 1))
addch('2')
refresh
timeout=(500)

setpos((l - 1),0)
addch('3')
refresh
timeout=(500)

setpos((l - 1),(c - 1))
addch('4')
refresh

setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Lines: #{l}, Columns: #{c}")
refresh

getch

flash
beep

endwin
return 0