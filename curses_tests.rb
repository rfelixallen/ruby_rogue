require 'curses'
include Curses

init_screen # Begin the standard screen.

# Test putting numbers in corner with a delay between each number.
setpos(0,0)
addch('1')
refresh
timeout=5000 # Set to 5 seconds so that I can confirm the delay.
flash

setpos(0,(cols - 1))
addch('2')
refresh
timeout=(5000)

setpos((lines - 1),0)
addch('3')
refresh
timeout=(5000)

setpos((lines - 1),(cols - 1))
addch('4')
refresh
timeout=(5000)

setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Lines: #{l}, Columns: #{c}")
refresh
getch


# Clear screen and give a goodbye message.
clear
setpos((lines - 5) / 2, (cols - 10) / 2)
addstr("Goodbye!")
refresh
getch
close_screen